import Foundation
import Architecture
import Models
import RxSwift
import Repository

private let querySymbols: [Character] = ["@"]

func updateAutocompleteSuggestionsEffect(_ state: StartEditState,
                                         _ repository: TimeLogRepository,
                                         _ description: String,
                                         _ position: Int) -> [Effect<StartEditAction>] {
    guard let query = state.editableTimeEntry?.description
        else { fatalError("No editable time entry while looking for autocomplete suggestions") }
    let result = Single.just(getSuggestions(for: query, at: position, in: state.entities))
        .map(StartEditAction.autocompleteSuggestionsUpdated)
        .toEffect()
    return [result]
}

private func getSuggestions(for query: String, at position: Int, in entities: TimeLogEntities) -> [AutocompleteSuggestion] {
    let caretIndex = query.index(query.startIndex, offsetBy: position)
    let querySymbolIndex = query[..<caretIndex]
        .enumerated()
        .filter { querySymbols.contains($0.element) }
        .map { $0.offset }
        .first(where: { index in
            let previous = index - 1
            if previous < 0 { return true }
            let previousIndex = query.index(query.startIndex, offsetBy: previous)
            return query[previousIndex].isWhitespace
        })
    
    if let index = querySymbolIndex {
        let startIndex = query.index(query.startIndex, offsetBy: index + 1)
        let endIndex = query.index(startIndex, offsetBy: query.count - index - 1)
        let searchQuery = query[startIndex..<endIndex]
        let words = searchQuery.split(separator: " ").map { String($0) }
        let projects = searchProjects(for: words, in: entities)
        var suggestions = projects.map(AutocompleteSuggestion.projectSuggestion)
        suggestions.insert(AutocompleteSuggestion.createProjectSuggestion(name: String(searchQuery)), at: 0)
        return suggestions
    }
    
    let words = query.split(separator: " ").map { String($0) }
    let timeEntries = searchTimeEntries(for: words, in: entities)
    return timeEntries.map(AutocompleteSuggestion.timeEntrySuggestion)
}

private func searchTimeEntries(for words: [String], in entities: TimeLogEntities) -> [TimeEntry] {
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
    }.sorted(by: { leftHand, rightHand in
        leftHand.description > rightHand.description
    })
}

private func searchProjects(for words: [String], in entities: TimeLogEntities) -> [Project] {
    
    func clientNameMatches(_ word: String, _ project: Project) -> Bool {
        guard let client = entities.getClient(project.clientId) else { return false }
        return client.name.contains(word)
    }
    
    return words.reduce(Array(entities.projects.values)) { projects, word in
        return projects.filter { project in
            return project.name.contains(word)
                || clientNameMatches(word, project)
        }
    }.sorted(by: { leftHand, rightHand in
        leftHand.name > rightHand.name
    })
}
