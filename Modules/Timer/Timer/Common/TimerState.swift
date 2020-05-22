import Foundation
import Models
import Utils

public struct TimerState: Equatable {
    public var user: Loadable<User>
    public var entities: TimeLogEntities

    private var _timeEntriesLogState: TimeEntriesLogState
    private var _startEditState: StartEditState?

    public init(user: Loadable<User>, entities: TimeLogEntities) {
        self.user = user
        self.entities = entities

        _timeEntriesLogState = TimeEntriesLogState(entities: entities)
    }
}

extension TimerState {
    public func isEditingGroup() -> Bool {
        guard let numberOfEntriesBeingEdited = _startEditState?.editableTimeEntry.ids.count else { return false }
        return numberOfEntriesBeingEdited > 1
    }
}

extension TimerState {
    
    internal var timeLogState: TimeEntriesLogState {
        get {
            var copy = _timeEntriesLogState
            copy.entities = entities
            return copy
        }
        set {
            _timeEntriesLogState = newValue
            entities = newValue.entities
        }
    }
    
    internal var startEditState: StartEditState? {
        get {
            if _startEditState == nil {
                return nil
            }

            var copy = _startEditState!
            copy.entities = entities
            return copy
        }
        set {
            _startEditState = newValue
            guard let newValue = newValue else { return }
            entities = newValue.entities
        }
    }

    internal var runningTimeEntryState: RunningTimeEntryState {
        get {
            RunningTimeEntryState(
                user: user,
                entities: entities
            )
        }
        set {
            user = newValue.user
            entities = newValue.entities
        }
    }
    
//    internal var projectState: ProjectState {
//        get {
//            ProjectState(
//                editableProject: editableTimeEntry?.editableProject,
//                projects: entities.projects
//            )
//        }
//        set {
//            entities.projects = newValue.projects
//            guard var timeEntry = editableTimeEntry else { return }
//            timeEntry.editableProject = newValue.editableProject
//        }
//    }
}
