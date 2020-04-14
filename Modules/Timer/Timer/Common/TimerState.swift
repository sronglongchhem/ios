import Foundation
import Models
import Utils

public struct LocalTimerState: Equatable {
    internal var editableTimeEntry: EditableTimeEntry?
    internal var expandedGroups: Set<Int> = Set<Int>()
    internal var entriesPendingDeletion = Set<Int64>()
    
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
                expandedGroups: localTimerState.expandedGroups
            )
        }
        set {
            entities = newValue.entities
            localTimerState.expandedGroups = newValue.expandedGroups
        }
    }
    
    internal var startEditState: StartEditState {
        get {
            StartEditState(
                user: user,
                entities: entities,
                editableTimeEntry: localTimerState.editableTimeEntry
            )
        }
        set {
            user = newValue.user
            entities = newValue.entities
            localTimerState.editableTimeEntry = newValue.editableTimeEntry
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
