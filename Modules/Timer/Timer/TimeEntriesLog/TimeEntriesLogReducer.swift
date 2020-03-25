import Foundation
import Architecture
import Models
import RxSwift
import Repository

class Scheduler
{
    var dict = [Int: PublishSubject<Void>]()
    
    init(){}
    
    func schedule(id: Int, scheduler: SchedulerType = MainScheduler.instance) -> Observable<Int>
    {
        let cancellation = PublishSubject<Void>()
        dict[id] = cancellation
        
        return Observable.just(id)            
            .delay(RxTimeInterval.seconds(3), scheduler: scheduler)
            .takeUntil(cancellation)
    }
    
    func cancel(id: Int)
    {
        guard let cancellation = dict[id] else { return }
        cancellation.onNext(())
    }
}

let scheduler = Scheduler()

let timeEntriesLogReducer = Reducer<TimeEntriesLogState, TimeEntriesLogAction, Repository> { state, action, repository in
    switch action {
        
    case let .continueButtonTapped(timeEntryId):
        for id in state.entriesToDelete {
            scheduler.cancel(id: id)
        }
        state.entriesToDelete = []
        return .empty
        //        guard let timeEntry = state.entities.timeEntries[timeEntryId] else { fatalError() }
        //        return continueTimeEntry(repository, timeEntry: timeEntry)
        
    case let .timeEntrySwiped(direction, timeEntryId):
        switch direction {
        case .left:
            if !state.entriesToDelete.isEmpty {
                let previous = Array(state.entriesToDelete).first!
                scheduler.cancel(id: previous)
                state.entriesToDelete.insert(timeEntryId)// = [timeEntryId]
                
                return Observable<TimeEntriesLogAction>.concat(
                    deleteTimeEntry(repository, timeEntryId: previous).asObservable(),
                    scheduleDeleteTimeEntry(timeEntryId: timeEntryId).asObservable()
                ).toEffect()
                
            } else {
                state.entriesToDelete = [timeEntryId]
                return scheduleDeleteTimeEntry(timeEntryId: timeEntryId)
            }
            
        case .right:
            guard let timeEntry = state.entities.timeEntries[timeEntryId] else { fatalError() }
            return continueTimeEntry(repository, timeEntry: timeEntry)
        }
        
    case let .deleteTimeEntry(timeEntryId):
        if state.entriesToDelete.contains(timeEntryId) {
            return deleteTimeEntry(repository, timeEntryId: timeEntryId)
        }
        return .empty
        
    case let .timeEntryTapped(timeEntryId):
        //TODO Probably change the route to show the selected TE...
        return .empty
        
    case let .timeEntryDeleted(timeEntryId):
        state.entriesToDelete.remove(timeEntryId)
        state.entities.timeEntries[timeEntryId] = nil
        return .empty
        
    case let .timeEntryAdded(timeEntry):
        state.entities.timeEntries[timeEntry.id] = timeEntry
        return .empty
        
    case .load:
        if state.entities.loading.isLoaded {
            return .empty
        }
        
        state.entities.loading = .loading
        return loadEntities(repository)
        
    case .finishedLoading:
        state.entities.loading = .loaded(())
        return .empty
        
    case let .setEntities(entities):        
        let dict: [Int: Entity] = entities.reduce([:], { acc, e in
            var acc = acc
            acc[e.id] = e
            return acc
        })
        
        state.entities.set(entities: dict)
        return .empty
        
    case let .setError(error):
        state.entities.loading = .error(error)
        return .empty
    }
}

fileprivate func loadEntities(_ repository: Repository) -> Effect<TimeEntriesLogAction>
{
    //TODO Shouldn't need to do all that `asObservable`
    return Observable.merge(
        repository.getWorkspaces().map(TimeEntriesLogAction.setEntities).asObservable(),
        repository.getClients().map(TimeEntriesLogAction.setEntities).asObservable(),
        repository.getTimeEntries().map(TimeEntriesLogAction.setEntities).asObservable(),
        repository.getProjects().map(TimeEntriesLogAction.setEntities).asObservable(),
        repository.getTasks().map(TimeEntriesLogAction.setEntities).asObservable(),
        repository.getTags().map(TimeEntriesLogAction.setEntities).asObservable()
    )
        .concat(Observable.just(.finishedLoading))
        .catchError({ Observable.just(.setError($0)) })
        .toEffect()
}

fileprivate func scheduleDeleteTimeEntry(timeEntryId: Int) -> Effect<TimeEntriesLogAction>
{
    scheduler.schedule(id: timeEntryId)
        .toEffect(
            map: { TimeEntriesLogAction.deleteTimeEntry($0) },
            catch: { TimeEntriesLogAction.setError($0)}
    )
}

fileprivate func deleteTimeEntry(_ repository: Repository, timeEntryId: Int) -> Effect<TimeEntriesLogAction>
{
    repository.deleteTimeEntry(timeEntryId: timeEntryId)
        .toEffect(
            map: { TimeEntriesLogAction.timeEntryDeleted(timeEntryId) },
            catch: { TimeEntriesLogAction.setError($0)}
    )
}

fileprivate func continueTimeEntry(_ repository: Repository, timeEntry: TimeEntry) -> Effect<TimeEntriesLogAction>
{
    var copy = timeEntry
    copy.id = UUID().hashValue
    copy.start = Date()
    copy.duration = -1
    
    return repository.addTimeEntry(timeEntry: copy)
        .toEffect(
            map: { TimeEntriesLogAction.timeEntryAdded(copy) },
            catch: { TimeEntriesLogAction.setError($0)}
    )
}
