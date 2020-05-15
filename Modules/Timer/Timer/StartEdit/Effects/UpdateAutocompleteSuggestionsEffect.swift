import Foundation
import Architecture
import Models
import RxSwift
import Repository

func updateAutocompleteSuggestionsEffect(_ state: StartEditState,
                                         _ repository: TimeLogRepository,
                                         _ description: String,
                                         _ position: Int) -> [Effect<StartEditAction>] {
    guard let query = state.editableTimeEntry?.description
        else { fatalError("No editable time entry while looking for autocomplete suggestions") }
    let words = query.split(separator: " ").map { String($0) }
    let timeEntries = searchTimeEntries(for: words, in: state.entities)
    let suggestions = timeEntries.map(AutocompleteSuggestion.timeEntrySuggestion)
    return [
        Single.just(suggestions)
            .map(StartEditAction.autocompleteSuggestionsUpdated)
            .toEffect()
    ]
}

func searchTimeEntries(for words: [String], in entities: TimeLogEntities) -> [TimeEntry] {
    func projectOrClientNameMatches(_ word: String, _ timeEntry: TimeEntry) -> Bool {
        guard let project = entities.getProject(timeEntry.projectId) else { return false }
        if project.name.contains(word) { return true }
        guard let client = entities.getClient(project.clientId) else { return false }
        return client.name.contains(word)
    }

    func tagNamesMatch(_ word: String, _ timeEntry: TimeEntry) -> Bool {
        guard timeEntry.tagIds.count > 0 else { return false }
        let tags = timeEntry.tagIds.compactMap(entities.getTag)
        if tags.count == 0 { return false }
        return tags.map { $0.name.contains(word) }
            .contains(true)
    }

    func taksNameMatches(_ word: String, _ timeEntry: TimeEntry) -> Bool {
        guard let task = entities.getTask(timeEntry.taskId) else { return false }
        return task.name.contains(word)
    }

    return words.reduce(Array(entities.timeEntries.values)) { timeEntries, word in
        return timeEntries.filter { timeEntry in
            return timeEntry.description.contains(word)
                || projectOrClientNameMatches(word, timeEntry)
                || tagNamesMatch(word, timeEntry)
                || taksNameMatches(word, timeEntry)
        }
    }.sorted(by: {leftHand, rightHand in
        leftHand.description > rightHand.description
    })
}
