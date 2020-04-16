import Foundation

public enum AutocompleteSuggestionType: Equatable {
    case timeEntrySuggestion(timeEntry: TimeEntry)
    case projectSuggestion(project: Project)
    case taskSuggestion(task: Task, project: Project)
    case tagSuggestion(tag: Tag)
    case createProjectSuggestion(name: String)
    case createTagSuggestion(name: String)
}
