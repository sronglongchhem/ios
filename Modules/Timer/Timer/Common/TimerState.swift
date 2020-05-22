import Foundation
import Models
import Utils

public struct LocalTimerState: Equatable {
    internal var editableTimeEntry: EditableTimeEntry?
    internal var expandedGroups: Set<Int> = Set<Int>()
    internal var entriesPendingDeletion = Set<Int64>()
    internal var autocompleteSuggestions: [AutocompleteSuggestion] = []
    internal var dateTimePickMode: DateTimePickMode = .none
    internal var cursorPosition: Int = 0
    
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

extension LocalTimerState {
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
                expandedGroups: localTimerState.expandedGroups,
                editableTimeEntry: localTimerState.editableTimeEntry,
                entriesPendingDeletion: localTimerState.entriesPendingDeletion
            )
        }
        set {
            entities = newValue.entities
            localTimerState.expandedGroups = newValue.expandedGroups
            localTimerState.editableTimeEntry = newValue.editableTimeEntry
            localTimerState.entriesPendingDeletion = newValue.entriesPendingDeletion
        }
    }
    
    internal var startEditState: StartEditState {
        get {
            StartEditState(
                user: user,
                entities: entities,
                editableTimeEntry: localTimerState.editableTimeEntry,
                autocompleteSuggestions: localTimerState.autocompleteSuggestions,
                dateTimePickMode: localTimerState.dateTimePickMode,
                cursorPosition: localTimerState.cursorPosition
            )
        }
        set {
            user = newValue.user
            entities = newValue.entities
            localTimerState.editableTimeEntry = newValue.editableTimeEntry
            localTimerState.autocompleteSuggestions = newValue.autocompleteSuggestions
            localTimerState.dateTimePickMode = newValue.dateTimePickMode
            localTimerState.cursorPosition = newValue.cursorPosition
        }
    }

    internal var runningTimeEntryState: RunningTimeEntryState {
        get {
            RunningTimeEntryState(
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
    
    internal var projectState: ProjectState {
        get {
            ProjectState(
                editableProject: localTimerState.editableTimeEntry?.editableProject,
                projects: entities.projects
            )
        }
        set {
            entities.projects = newValue.projects
            guard var timeEntry = localTimerState.editableTimeEntry else { return }
            timeEntry.editableProject = newValue.editableProject
        }
    }
}
