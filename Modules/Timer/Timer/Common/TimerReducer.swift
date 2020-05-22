import Foundation
import Architecture
import Models

let timerReducer = Reducer<TimerState, TimerAction> { state, action in
    switch action {

    case let .timeLog(.timeEntryTapped(timeEntryId)):
        state.editableTimeEntry = EditableTimeEntry.fromSingle(state.entities.timeEntries[timeEntryId]!)
        return []

    case let .timeLog(.timeEntryGroupTapped(timeEntryIds)):
        state.editableTimeEntry = EditableTimeEntry.fromGroup(
            ids: timeEntryIds,
            groupSample: state.entities.timeEntries[timeEntryIds.first!]!
        )
        return []

    case .timeLog:
        return []

    case .runningTimeEntry(.cardTapped):
        if let runningTimeEntryId = runningTimeEntry(state.entities)?.id {
            guard let runningTimeEntry = state.entities.timeEntries[runningTimeEntryId]
                else { return [] }

            state.editableTimeEntry = EditableTimeEntry.fromSingle(runningTimeEntry)
            return []
        }

        guard case let Loadable.loaded(user) = state.user else { return [] }
        state.editableTimeEntry = EditableTimeEntry.empty(workspaceId: user.defaultWorkspace)

        return []

    case .runningTimeEntry:
        return []

    case .startEdit, .project:
        return []
    }
}
