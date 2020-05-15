import Foundation
import Architecture
import Models
import RxSwift
import Repository

func updateAutocompleteSuggestionsEffect(_ state: StartEditState,
                                         _ repository: TimeLogRepository,
                                         _ description: String,
                                         _ position: Int) -> [Effect<StartEditAction>] {
    guard let query = state.editableTimeEntry?.description else { return [] }
    let queryTerms = query.split(separator: " ").map { String($0) }
    let timeEntries = queryTerms.flatMap { search(for: $0, in: state.entities)}
    let suggestions = timeEntries.map(AutocompleteSuggestion.timeEntrySuggestion)
    return [
        Single.just(suggestions)
            .map(StartEditAction.autocompleteSuggestionsUpdated)
            .toEffect()
    ]
}

func search(for term: String, in entities: TimeLogEntities) -> [TimeEntry] {
    func projectOrClientNameMatches(_ timeEntry: TimeEntry) -> Bool {
        guard let project = entities.getProject(timeEntry.projectId) else { return false }
        if project.name.contains(term) { return true }
        guard let client = entities.getClient(project.clientId) else { return false }
        return client.name.contains(term)
    }

    func tagNamesMatch(_ timeEntry: TimeEntry) -> Bool {
        guard timeEntry.tagIds.count > 0 else { return false }
        let tags = timeEntry.tagIds.compactMap(entities.getTag)
        if tags.count == 0 { return false }
        return tags.map { $0.name.contains(term) }
            .contains(true)
    }

    func taksNameMatches(_ timeEntry: TimeEntry) -> Bool {
        guard let task = entities.getTask(timeEntry.taskId) else { return false }
        return task.name.contains(term)
    }

    return entities.timeEntries.values.filter { timeEntry in
        return timeEntry.description.contains(term)
            || projectOrClientNameMatches(timeEntry)
            || tagNamesMatch(timeEntry)
            || taksNameMatches(timeEntry)
    }.sorted(by: {leftHand, rightHand in
        leftHand.description > rightHand.description
    })
}
