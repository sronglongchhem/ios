import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
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
                return deleteWithUndo(timeEntryIds: [timeEntryId], state: &state, repository: repository)
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
                return deleteWithUndo(timeEntryIds: Set(timeEntryIds), state: &state, repository: repository)
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

        case let .commitDeletion(timeEntryIds):
            let timeEntryIdsToDelete = state.entriesPendingDeletion == timeEntryIds
                ? timeEntryIds
                : []

            guard !timeEntryIdsToDelete.isEmpty else { return [] }

            state.entriesPendingDeletion.removeAll()
            return timeEntryIdsToDelete.sorted().map {
                deleteTimeEntry(repository, timeEntryId: $0)
            }
            
        case .undoButtonTapped:
            state.entriesPendingDeletion.removeAll()
            return []
        }
    }
}

private func deleteWithUndo(
    timeEntryIds: Set<Int64>,
    state: inout TimeEntriesLogState,
    repository: TimeLogRepository
) -> [Effect<TimeEntriesLogAction>] {
    let timeEntryIdsSet = timeEntryIds
    if state.entriesPendingDeletion.isEmpty {
        state.entriesPendingDeletion = timeEntryIdsSet
        return [waitForUndoEffect(timeEntryIdsSet)]
    } else {
        let teIdsToDeleteImmediately = state.entriesPendingDeletion
        state.entriesPendingDeletion = timeEntryIdsSet
        var actions = teIdsToDeleteImmediately.sorted().map {
            deleteTimeEntry(repository, timeEntryId: $0)
        }
        actions.append(waitForUndoEffect(timeEntryIdsSet))
        return actions
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

private func waitForUndoEffect(_ entriesToDelete: Set<Int64>) -> Effect<TimeEntriesLogAction> {
    return Observable.just(TimeEntriesLogAction.commitDeletion(entriesToDelete))
        .delay(RxTimeInterval.seconds(TimerConstants.timeEntryDeletionDelaySeconds), scheduler: MainScheduler.instance)
        .toEffect()
}
