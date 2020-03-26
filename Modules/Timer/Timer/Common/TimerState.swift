import Foundation
import Models
import Utils

public struct LocalTimerState: Equatable {
    internal var description: String = ""
    internal var expandedGroups = Set<Int>()

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
                description: localTimerState.description
            )
        }
        set {
            user = newValue.user
            entities = newValue.entities
            localTimerState.description = newValue.description
        }
    }
}
