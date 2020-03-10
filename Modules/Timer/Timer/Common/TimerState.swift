import Foundation
import Models
import Utils

public struct LocalTimerState
{
    internal var description: String = ""
    internal var entriesToDelete: Set<Int> = Set<Int>()
    
    public init()
    {
    }
}

public struct TimerState
{
    public var user: Loadable<User>
    public var entities: TimeLogEntities
    public var localTimerState: LocalTimerState
    
    public init(user: Loadable<User>, entities: TimeLogEntities, localTimerState: LocalTimerState) {
        self.user = user
        self.entities = entities
        self.localTimerState = localTimerState
    }
}

extension TimerState
{
    internal var timeLogState: TimeEntriesLogState
    {
        get {
            TimeEntriesLogState(entities: entities, entriesToDelete: localTimerState.entriesToDelete)
        }
        set {
            entities = newValue.entities
            localTimerState.entriesToDelete = newValue.entriesToDelete
        }
    }
    
    internal var startEditState: StartEditState
    {
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
