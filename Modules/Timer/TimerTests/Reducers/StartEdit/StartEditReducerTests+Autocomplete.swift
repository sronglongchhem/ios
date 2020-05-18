import XCTest
import Architecture
import Models
import OtherServices
@testable import Timer

extension StartEditReducerTests {
    
    // MARK: Time Entries
    
    func test_autocomplete_withNoTokens_returnsTimeEntriesMatchingByDescription() {
        let timeEntries = ["Match", "Match as well", "Not this", "Nor this"].enumerated()
            .map { TimeEntry.with(id: Int64($0.offset), description: $0.element) }
        
        let expectedSuggestions = timeEntries[..<2].sorted(by: {leftHand, rightHand in
            leftHand.description > rightHand.description
        }).map(AutocompleteSuggestion.timeEntrySuggestion)
        
        var entities = TimeLogEntities()
        entities.timeEntries = Dictionary(uniqueKeysWithValues: timeEntries.map { ($0.id, $0) })
        
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [],
            dateTimePickMode: .none)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "Match"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
    
    func test_autocomplete_withNoTokens_returnsTimeEntriesMatchingByProjectName() {
        let projects = ["Match", "Match as well", "Not this", "Nor this"].enumerated()
            .map { Project.with(id: Int64($0.offset), name: $0.element) }
        let timeEntries = projects.map { project -> TimeEntry in
            var timeEntry = TimeEntry.with(description: "Time entry for \(project.id)")
            timeEntry.projectId = project.id
            return timeEntry
        }
        
        let expectedSuggestions = timeEntries[..<2].sorted(by: {leftHand, rightHand in
            leftHand.description > rightHand.description
        }).map(AutocompleteSuggestion.timeEntrySuggestion)
        
        var entities = TimeLogEntities()
        entities.projects = Dictionary(uniqueKeysWithValues: projects.map { ($0.id, $0) })
        entities.timeEntries = Dictionary(uniqueKeysWithValues: timeEntries.map { ($0.id, $0) })
        
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [],
            dateTimePickMode: .none)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "Match"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
    
    func test_autocomplete_withNoTokens_returnsTimeEntriesMatchingByClientName() {
        let clients = ["Match", "Match as well", "Not this", "Nor this"].enumerated()
            .map { Client(id: Int64($0.offset), name: $0.element, workspaceId: mockUser.defaultWorkspace)}
        let projects = clients.map { client -> Project in
            Project.with(clientId: client.id)
        }
        let timeEntries = projects.map { project -> TimeEntry in
            var timeEntry = TimeEntry.with(description: "Time entry for \(project.id)")
            timeEntry.projectId = project.id
            return timeEntry
        }
        
        let expectedSuggestions = timeEntries[..<2].sorted(by: {leftHand, rightHand in
            leftHand.description > rightHand.description
        }).map(AutocompleteSuggestion.timeEntrySuggestion)
        
        var entities = TimeLogEntities()
        entities.clients = Dictionary(uniqueKeysWithValues: clients.map { ($0.id, $0) })
        entities.projects = Dictionary(uniqueKeysWithValues: projects.map { ($0.id, $0) })
        entities.timeEntries = Dictionary(uniqueKeysWithValues: timeEntries.map { ($0.id, $0) })
        
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [],
            dateTimePickMode: .none)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "Match"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
    
    func test_autocomplete_withNoTokens_returnsTimeEntriesMatchingByTaskName() {
        let tasks = ["Match", "Match as well", "Not this", "Nor this"].enumerated()
            .map { Task.with(id: Int64($0.offset), name: $0.element) }
        let timeEntries = tasks.map { task -> TimeEntry in
            var timeEntry = TimeEntry.with(description: "Time entry for \(task.id)")
            timeEntry.taskId = task.id
            return timeEntry
        }
        
        let expectedSuggestions = timeEntries[..<2].sorted(by: {leftHand, rightHand in
            leftHand.description > rightHand.description
        }).map(AutocompleteSuggestion.timeEntrySuggestion)
        
        var entities = TimeLogEntities()
        entities.tasks = Dictionary(uniqueKeysWithValues: tasks.map { ($0.id, $0) })
        entities.timeEntries = Dictionary(uniqueKeysWithValues: timeEntries.map { ($0.id, $0) })
        
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [],
            dateTimePickMode: .none)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "Match"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
    
    func test_autocomplete_withNoTokens_returnsTimeEntriesMatchingByTagName() {
        let tags = ["Match", "Match as well", "Not this", "Nor this"].enumerated()
            .map { Tag(id: Int64($0.offset), name: $0.element, workspaceId: mockUser.defaultWorkspace) }
        let timeEntries = tags.map { tag -> TimeEntry in
            var timeEntry = TimeEntry.with(description: "Time entry for \(tag.id)")
            timeEntry.tagIds = [tag.id]
            return timeEntry
        }
        
        let expectedSuggestions = timeEntries[..<2].sorted(by: {leftHand, rightHand in
            leftHand.description > rightHand.description
        }).map(AutocompleteSuggestion.timeEntrySuggestion)
        
        var entities = TimeLogEntities()
        entities.tags = Dictionary(uniqueKeysWithValues: tags.map { ($0.id, $0) })
        entities.timeEntries = Dictionary(uniqueKeysWithValues: timeEntries.map { ($0.id, $0) })
        
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [],
            dateTimePickMode: .none)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "Match"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }

    func test_autocomplete_withNoTokens_returnsTimeEntriesMatchingMultipleWordsAcrossMultipleEntities() {
        let tags = tagsForAutocompletionTest()
        let clients = clientsForAutocompletionTest()
        let projects = projectsForAutocompletionTest()
        let tasks = tasksForAutocompletionTest()
        let timeEntries = timeEntriesForAutocompletionTest()
        
        let expectedSuggestions = timeEntries[..<5].sorted(by: {leftHand, rightHand in
                leftHand.description > rightHand.description
            }).map(AutocompleteSuggestion.timeEntrySuggestion)
        
        var entities = TimeLogEntities()
        entities.tags = Dictionary(uniqueKeysWithValues: tags.map { ($0.id, $0) })
        entities.clients = Dictionary(uniqueKeysWithValues: clients.map { ($0.id, $0) })
        entities.projects = Dictionary(uniqueKeysWithValues: projects.map { ($0.id, $0) })
        entities.tasks = Dictionary(uniqueKeysWithValues: tasks.map { ($0.id, $0) })
        entities.timeEntries = Dictionary(uniqueKeysWithValues: timeEntries.map { ($0.id, $0) })
        
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [],
            dateTimePickMode: .none)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "word1 word2"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
    
    // MARK: Projects
    
    func test_autocomplete_withProjectToken_returnsProjectsMatchingByName() {
        let projects = ["Match", "Match as well", "Not this", "Nor this"].enumerated()
            .map { Project.with(id: Int64($0.offset), name: $0.element) }
        
        var expectedSuggestions = projects[..<2].sorted(by: {leftHand, rightHand in
            leftHand.name > rightHand.name
        }).map(AutocompleteSuggestion.projectSuggestion)
        expectedSuggestions.insert(AutocompleteSuggestion.createProjectSuggestion(name: "Match"), at: 0)
        
        var entities = TimeLogEntities()
        entities.projects = Dictionary(uniqueKeysWithValues: projects.map { ($0.id, $0) })
        
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [],
            dateTimePickMode: .none)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "@Match"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
    
    func test_autocomplete_withProjectToken_returnsProjectsMatchingByClientName() {
        let clients = ["Match", "Match as well", "Not this", "Nor this"].enumerated()
            .map { Client(id: Int64($0.offset), name: $0.element, workspaceId: mockUser.defaultWorkspace)}
        let projects = clients.map { client -> Project in
            Project.with(name: "Project with client \(client.id)", clientId: client.id)
        }
        
        var expectedSuggestions = projects[..<2].sorted(by: {leftHand, rightHand in
            leftHand.name > rightHand.name
        }).map(AutocompleteSuggestion.projectSuggestion)
        expectedSuggestions.insert(AutocompleteSuggestion.createProjectSuggestion(name: "Match"), at: 0)
        
        var entities = TimeLogEntities()
        entities.clients = Dictionary(uniqueKeysWithValues: clients.map { ($0.id, $0) })
        entities.projects = Dictionary(uniqueKeysWithValues: projects.map { ($0.id, $0) })
        
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [],
            dateTimePickMode: .none)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "@Match"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
    
    func test_autocomplete_withProjectToken_returnsProjectsMatchingMultipleWordsAcrossMultipleEntities() {
        let tags = tagsForAutocompletionTest()
        let clients = clientsForAutocompletionTest()
        let projects = projectsForAutocompletionTest()
        let tasks = tasksForAutocompletionTest()
        let timeEntries = timeEntriesForAutocompletionTest()
        
        var expectedSuggestions = [projects.first!, projects.last!].sorted(by: {leftHand, rightHand in
                leftHand.name > rightHand.name
            }).map(AutocompleteSuggestion.projectSuggestion)
        expectedSuggestions.insert(AutocompleteSuggestion.createProjectSuggestion(name: "word1 word2"), at: 0)
        
        var entities = TimeLogEntities()
        entities.tags = Dictionary(uniqueKeysWithValues: tags.map { ($0.id, $0) })
        entities.clients = Dictionary(uniqueKeysWithValues: clients.map { ($0.id, $0) })
        entities.projects = Dictionary(uniqueKeysWithValues: projects.map { ($0.id, $0) })
        entities.tasks = Dictionary(uniqueKeysWithValues: tasks.map { ($0.id, $0) })
        entities.timeEntries = Dictionary(uniqueKeysWithValues: timeEntries.map { ($0.id, $0) })
        
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [],
            dateTimePickMode: .none)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "Testing @word1 word2"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
 
    private func clientsForAutocompletionTest() -> [Client] {
        return [
            Client(id: 0, name: "word1", workspaceId: mockUser.defaultWorkspace),
            Client(id: 1, name: "word1 word2", workspaceId: mockUser.defaultWorkspace)
        ]
    }

    private func projectsForAutocompletionTest() -> [Project] {
        return [
            Project.with(
                id: 0,
                name: "word2word1",
                clientId: 0
            ),
            Project.with(
                id: 1,
                name: "word1",
                clientId: 0
            ),
            Project.with(
                id: 2,
                name: "word2",
                clientId: 1
            )
        ]
    }

    private func tagsForAutocompletionTest() -> [Tag] {
        return [
            Tag(id: 0, name: "word1 word2word3", workspaceId: mockUser.defaultWorkspace),
            Tag(id: 1, name: "word1", workspaceId: mockUser.defaultWorkspace)
        ]
    }

    private func tasksForAutocompletionTest() -> [Task] {
        return [
            Task.with(id: 0, name: "word1word2", projectId: 1),
            Task.with(id: 1, name: "word2", projectId: 1)
        ]
    }

    private func timeEntriesForAutocompletionTest() -> [TimeEntry] {
        return [
            timeEntryMatchByName(),
            timeEntryMatchByProjectName(),
            timeEntryMatchByClientName(),
            timeEntryMatchByTagName(),
            timeEntryMatchByTaskName(),
            timeEntryDontMatchByName(),
            timeEntryDontMatchByProjectName(),
            timeEntryDontMatchByTagName(),
            timeEntryDontMatchByTaskName()
        ]
    }

    private func timeEntryMatchByName() -> TimeEntry {
        return TimeEntry.with(id: 0, description: "a word2 word1")
    }

    private func timeEntryMatchByProjectName() -> TimeEntry {
        var timeEntry = TimeEntry.with(id: 1, description: "b word2 word3")
        timeEntry.projectId = 0
        return timeEntry
    }

    private func timeEntryMatchByClientName() -> TimeEntry {
        var timeEntry = TimeEntry.with(id: 2, description: "c wo rd 2")
        timeEntry.projectId = 2
        return timeEntry
    }

    private func timeEntryMatchByTagName() -> TimeEntry {
        var timeEntry = TimeEntry.with(id: 3, description: "d wo rd1 wo rd2")
        timeEntry.tagIds = [0]
        return timeEntry
    }

    private func timeEntryMatchByTaskName() -> TimeEntry {
        var timeEntry = TimeEntry.with(id: 4, description: "e word1")
        timeEntry.taskId = 0
        return timeEntry
    }

    private func timeEntryDontMatchByName() -> TimeEntry {
        return TimeEntry.with(id: 5, description: "f word4")
    }

    private func timeEntryDontMatchByProjectName() -> TimeEntry {
        var timeEntry = TimeEntry.with(id: 6, description: "g word5")
        timeEntry.projectId = 1
        return timeEntry
    }

    private func timeEntryDontMatchByTagName() -> TimeEntry {
        var timeEntry = TimeEntry.with(id: 7, description: "h w o r d 1 w o r d 2")
        timeEntry.tagIds = [1]
        return timeEntry
    }

    private func timeEntryDontMatchByTaskName() -> TimeEntry {
        var timeEntry = TimeEntry.with(id: 8, description: "i wor1dword2")
        timeEntry.taskId = 1
        return timeEntry
    }
}
