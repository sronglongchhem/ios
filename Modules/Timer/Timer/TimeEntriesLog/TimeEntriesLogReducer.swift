import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

// swiftlint:disable cyclomatic_complexity
func createTimeEntriesLogReducer(repository: TimeLogRepository, time: Time) -> Reducer<TimeEntriesLogState, TimeEntriesLogAction> {
    return Reducer { state, action in
        switch action {

        case let .continueButtonTapped(timeEntryId):
            return [
                continueTimeEntry(repository, time: time, timeEntry: state.entities.timeEntries[timeEntryId]!)
            ]
            
        case let .timeEntrySwiped(direction, timeEntryId):
            switch direction {
            case .left:
                return [deleteTimeEntry(repository, timeEntryId: timeEntryId)]
            case .right:
                return [continueTimeEntry(repository, time: time, timeEntry: state.entities.timeEntries[timeEntryId]!)]
            }
            
        case .timeEntryTapped:
            return []
            
        case let .toggleTimeEntryGroupTapped(groupId):
            if state.expandedGroups.contains(groupId) {
                 state.expandedGroups.remove(groupId)
             } else {
                 state.expandedGroups.insert(groupId)
             }
             return []
            
        case let .timeEntryGroupSwiped(direction, timeEntryIds):
            switch direction {
            case .left:
                return timeEntryIds.map {
                    deleteTimeEntry(repository, timeEntryId: $0)
                }
            case .right:
                return [continueTimeEntry(repository, time: time, timeEntry: state.entities.timeEntries[timeEntryIds.first!]!)]
            }
            
        case let .timeEntryDeleted(timeEntryId):
            state.entities.timeEntries[timeEntryId] = nil
            return []
            
        case let .timeEntryStarted(startedTimeEntry, stoppedTimeEntry):
            if let stoppedTimeEntry = stoppedTimeEntry {
                state.entities.timeEntries[stoppedTimeEntry.id] = stoppedTimeEntry
            }
            state.entities.timeEntries[startedTimeEntry.id] = startedTimeEntry

            return []
            
        case let .setError(error):
            fatalError(error.description)
        }
    }
}

private func deleteTimeEntry(_ repository: TimeLogRepository, timeEntryId: Int64) -> Effect<TimeEntriesLogAction> {
    repository.deleteTimeEntry(timeEntryId: timeEntryId)
        .toEffect(
            map: { TimeEntriesLogAction.timeEntryDeleted(timeEntryId) },
            catch: { TimeEntriesLogAction.setError($0.toErrorType())}
    )
}

private func continueTimeEntry(_ repository: TimeLogRepository, time: Time, timeEntry: TimeEntry) -> Effect<TimeEntriesLogAction> {
    return repository.startTimeEntry(timeEntry.toStartTimeEntryDto())
        .toEffect(
            map: { TimeEntriesLogAction.timeEntryStarted($0, $1) },
            catch: { TimeEntriesLogAction.setError($0.toErrorType())}
    )
}
