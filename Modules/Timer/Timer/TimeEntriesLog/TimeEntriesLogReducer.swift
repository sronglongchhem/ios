import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

func createTimeEntriesLogReducer(repository: TimeLogRepository, time: Time) -> Reducer<[Int: TimeEntry], TimeEntriesLogAction> {
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
            
        case let .timeEntryStarted(startedTimeEntry, stoppedTimeEntry):
            if let stoppedTimeEntry = stoppedTimeEntry {
                state[stoppedTimeEntry.id] = stoppedTimeEntry
            }
            state[startedTimeEntry.id] = startedTimeEntry
            return []
            
        case let .setError(error):
            fatalError(error.description)
        }
    }
}

private func timeEntrySwiped(_ repository: TimeLogRepository,
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

private func deleteTimeEntry(_ repository: TimeLogRepository, timeEntryId: Int) -> Effect<TimeEntriesLogAction> {
    repository.deleteTimeEntry(timeEntryId: timeEntryId)
        .toEffect(
            map: { TimeEntriesLogAction.timeEntryDeleted(timeEntryId) },
            catch: { TimeEntriesLogAction.setError($0.toErrorType())}
    )
}

private func continueTimeEntry(_ repository: TimeLogRepository,
                               time: Time,
                               state: [Int: TimeEntry],
                               timeEntryId: Int)
    -> Effect<TimeEntriesLogAction> {
        guard let timeEntry = state[timeEntryId] else { fatalError() }
        
        var copy = timeEntry
        copy.start = time.now()
        copy.duration = 0
        
        return repository.startTimeEntry(timeEntry: copy)
            .toEffect(
                map: { TimeEntriesLogAction.timeEntryStarted($0, $1) },
                catch: { TimeEntriesLogAction.setError($0.toErrorType())}
        )
}
