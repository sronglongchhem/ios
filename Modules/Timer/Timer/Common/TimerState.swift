import Foundation
import Models
import Utils

public struct LocalTimerState: Equatable {
    internal var editableTimeEntry: EditableTimeEntry?
    internal var expandedGroups: Set<Int> = Set<Int>()
    internal var entriesPendingDeletion = Set<Int64>()
    internal var autocompleteSuggestions: [AutocompleteSuggestionType] = []
    
    public init() {
    }
}

public struct TimerState: Equatable {
    public var user: Loadable<User>
    public var entities: TimeLogEntities
    public var localTimerState: LocalTimerState
    
    public init(user: Loadable<User>, entities: TimeLogEntities, localTimerState: LocalTimerState) {
        self.user = user
        self.entities = entities
        self.localTimerState = localTimerState
    }
}

extension TimerState {
    
    internal var timeLogState: TimeEntriesLogState {
        get {
            TimeEntriesLogState(
                entities: entities,
                expandedGroups: localTimerState.expandedGroups,
                entriesPendingDeletion: localTimerState.entriesPendingDeletion
            )
        }
        set {
            entities = newValue.entities
            localTimerState.expandedGroups = newValue.expandedGroups
            localTimerState.entriesPendingDeletion = newValue.entriesPendingDeletion
        }
    }
    
    internal var startEditState: StartEditState {
        get {
            StartEditState(
                user: user,
                entities: entities,
                editableTimeEntry: localTimerState.editableTimeEntry,
                autocompleteSuggestions: localTimerState.autocompleteSuggestions
            )
        }
        set {
            user = newValue.user
            entities = newValue.entities
            localTimerState.editableTimeEntry = newValue.editableTimeEntry
            localTimerState.autocompleteSuggestions = newValue.autocompleteSuggestions
        }
    }

    internal var runningTimeEntryState: RunningTimeEntryState {
        get {
            RunningTimeEntryState(
                entities: entities
            )
        }
        set {
            entities = newValue.entities
        }
    }
}
