import Foundation
import Models
import Utils

public struct TimerState: Equatable {
    public var user: Loadable<User>
    public var entities: TimeLogEntities

    internal var editableTimeEntry: EditableTimeEntry?
    internal var expandedGroups: Set<Int> = Set<Int>()
    internal var entriesPendingDeletion = Set<Int64>()
    internal var autocompleteSuggestions: [AutocompleteSuggestion] = []
    internal var dateTimePickMode: DateTimePickMode = .none
    internal var cursorPosition: Int = 0

    public init(user: Loadable<User>, entities: TimeLogEntities) {
        self.user = user
        self.entities = entities
    }
}

extension TimerState {
    public func isEditingGroup() -> Bool {
        guard let numberOfEntriesBeingEdited = editableTimeEntry?.ids.count else { return false }
        return numberOfEntriesBeingEdited > 1
    }
}

extension TimerState {
    
    internal var timeLogState: TimeEntriesLogState {
        get {
            TimeEntriesLogState(
                entities: entities,
                expandedGroups: expandedGroups,
                editableTimeEntry: editableTimeEntry,
                entriesPendingDeletion: entriesPendingDeletion
            )
        }
        set {
            entities = newValue.entities
            expandedGroups = newValue.expandedGroups
            editableTimeEntry = newValue.editableTimeEntry
            entriesPendingDeletion = newValue.entriesPendingDeletion
        }
    }
    
    internal var startEditState: StartEditState {
        get {
            StartEditState(
                user: user,
                entities: entities,
                editableTimeEntry: editableTimeEntry,
                autocompleteSuggestions: autocompleteSuggestions,
                dateTimePickMode: dateTimePickMode,
                cursorPosition: cursorPosition
            )
        }
        set {
            user = newValue.user
            entities = newValue.entities
            editableTimeEntry = newValue.editableTimeEntry
            autocompleteSuggestions = newValue.autocompleteSuggestions
            dateTimePickMode = newValue.dateTimePickMode
            cursorPosition = newValue.cursorPosition
        }
    }

    internal var runningTimeEntryState: RunningTimeEntryState {
        get {
            RunningTimeEntryState(
                user: user,
                entities: entities,
                editableTimeEntry: editableTimeEntry
            )
        }
        set {
            user = newValue.user
            entities = newValue.entities
            editableTimeEntry = newValue.editableTimeEntry
        }
    }
    
    internal var projectState: ProjectState {
        get {
            ProjectState(
                editableProject: editableTimeEntry?.editableProject,
                projects: entities.projects
            )
        }
        set {
            entities.projects = newValue.projects
            guard var timeEntry = editableTimeEntry else { return }
            timeEntry.editableProject = newValue.editableProject
        }
    }
}
