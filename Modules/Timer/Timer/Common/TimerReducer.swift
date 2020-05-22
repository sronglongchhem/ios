import Foundation
import Architecture

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

    case .startEdit, .runningTimeEntry, .project:
        return []
    }
}
