import Foundation
import Architecture
import Models

let timerReducer = Reducer<TimerState, TimerAction> { state, action in
    switch action {

    case let .timeLog(.timeEntryTapped(timeEntryId)):
        state.startEditState = StartEditState(
            entities: state.entities,
            editableTimeEntry: EditableTimeEntry.fromSingle(state.entities.timeEntries[timeEntryId]!)
        )
        return []

    case let .timeLog(.timeEntryGroupTapped(timeEntryIds)):
        state.startEditState = StartEditState(
            entities: state.entities,
            editableTimeEntry: EditableTimeEntry.fromGroup(
                ids: timeEntryIds,
                groupSample: state.entities.timeEntries[timeEntryIds.first!]!
            )
        )
        return []

    case .timeLog:
        return []

    case .runningTimeEntry(.cardTapped):
        if let runningTimeEntryId = runningTimeEntry(state.entities)?.id {
            guard let runningTimeEntry = state.entities.timeEntries[runningTimeEntryId]
                else { return [] }

            state.startEditState = StartEditState(
                entities: state.entities,
                editableTimeEntry: EditableTimeEntry.fromSingle(runningTimeEntry)
            )
            return []
        }

        guard case let Loadable.loaded(user) = state.user else { return [] }
        state.startEditState =  StartEditState(
            entities: state.entities,
            editableTimeEntry: EditableTimeEntry.empty(workspaceId: user.defaultWorkspace)
        )

        return []

    case .runningTimeEntry:
        return []

    case let .startEdit(.timeEntryStarted(startedTimeEntry, stoppedTimeEntry)):
        state.entities.timeEntries[startedTimeEntry.id] = startedTimeEntry
        if let stoppedTimeEntry = stoppedTimeEntry {
            state.entities.timeEntries[stoppedTimeEntry.id] = stoppedTimeEntry
        }
        state.startEditState = nil
        return []

    case let .startEdit(.timeEntryUpdated(timeEntry)):
        state.entities.timeEntries[timeEntry.id] = timeEntry
        state.startEditState = nil
        return []

    case .startEdit(.closeButtonTapped), .startEdit(.dialogDismissed):
        state.startEditState = nil
        return []

    case .startEdit:
        return []

    case .project:
        return []
    }
}
