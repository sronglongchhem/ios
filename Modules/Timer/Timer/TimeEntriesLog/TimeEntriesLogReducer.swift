import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

func createTimeEntriesLogReducer(repository: Repository, time: Time) -> Reducer<[Int: TimeEntry], TimeEntriesLogAction> {
    return Reducer { state, action in
        switch action {

        case let .continueButtonTapped(timeEntryId):
            return [
                continueTimeEntry(repository, time: time, state: state, timeEntryId: timeEntryId)
            ]
            
        case let .timeEntrySwiped(direction, timeEntryId):
            return [
                timeEntrySwiped(repository, time: time, state: state, direction: direction, timeEntryId: timeEntryId)
            ]
            
        case .timeEntryTapped:
            return []
            
        case let .timeEntryDeleted(timeEntryId):
            state[timeEntryId] = nil
            return []
            
        case let .timeEntryAdded(timeEntry):
            state[timeEntry.id] = timeEntry
            return []
            
        case let .setError(error):
            fatalError(error.localizedDescription)
        }
    }
}

private func timeEntrySwiped(_ repository: Repository,
                             time: Time,
                             state: [Int: TimeEntry],
                             direction: SwipeDirection,
                             timeEntryId: Int)
    -> Effect<TimeEntriesLogAction> {
    switch direction {
    case .left:
        return deleteTimeEntry(repository, timeEntryId: timeEntryId)
    case .right:
        return continueTimeEntry(repository, time: time, state: state, timeEntryId: timeEntryId)
    }
}

private func deleteTimeEntry(_ repository: Repository, timeEntryId: Int) -> Effect<TimeEntriesLogAction> {
    repository.deleteTimeEntry(timeEntryId: timeEntryId)
        .toEffect(
            map: { TimeEntriesLogAction.timeEntryDeleted(timeEntryId) },
            catch: { TimeEntriesLogAction.setError($0)}
    )
}

private func continueTimeEntry(_ repository: Repository, time: Time, state: [Int: TimeEntry], timeEntryId: Int) -> Effect<TimeEntriesLogAction> {
    guard let timeEntry = state[timeEntryId] else { fatalError() }

    var copy = timeEntry
    copy.id = UUID().hashValue
    copy.start = time.now()
    copy.duration = -1

    return repository.addTimeEntry(timeEntry: copy)
        .toEffect(
            map: { TimeEntriesLogAction.timeEntryAdded(copy) },
            catch: { TimeEntriesLogAction.setError($0)}
    )
}
