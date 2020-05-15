import XCTest
import Architecture
import Models
import OtherServices
@testable import Timer

extension StartEditReducerTests {
    
    func test_descriptionEntered_withNoTokens_shouldBringUpTimeEntryAutocompleteSuggestions() {
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
            descriptionEnteredStep(for: "Match"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
    
    func test_descriptionEntered_withProjectToken_shouldBringUpProjectAutocompleteSuggestions() {
        let tags = tagsForAutocompletionTest()
        let clients = clientsForAutocompletionTest()
        let projects = projectsForAutocompletionTest()
        let tasks = tasksForAutocompletionTest()
        let timeEntries = timeEntriesForAutocompletionTest()
        
        var expectedSuggestions = [projects.first!, projects.last!].sorted(by: {leftHand, rightHand in
                leftHand.name > rightHand.name
            }).map(AutocompleteSuggestion.projectSuggestion)
        expectedSuggestions.insert(AutocompleteSuggestion.createProjectSuggestion(name: "Match"), at: 0)
        
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
            descriptionEnteredStep(for: "Testing @Match"),
            Step(.receive, StartEditAction.autocompleteSuggestionsUpdated(expectedSuggestions)) {
                $0.autocompleteSuggestions = expectedSuggestions
            }
        )
    }
 
    private func clientsForAutocompletionTest() -> [Client] {
        return [
            Client(id: 0, name: "Not this one", workspaceId: mockUser.defaultWorkspace),
            Client(id: 1, name: "Matching", workspaceId: mockUser.defaultWorkspace)
        ]
    }

    private func projectsForAutocompletionTest() -> [Project] {
        return [
            Project(
                id: 0,
                name: "Matching",
                isPrivate: false,
                isActive: true,
                color: "#000000",
                billable: nil,
                workspaceId: mockUser.defaultWorkspace,
                clientId: 0
            ),
            Project(
                id: 1,
                name: "Not this one",
                isPrivate: false,
                isActive: true,
                color: "#000000",
                billable: nil,
                workspaceId: mockUser.defaultWorkspace,
                clientId: 0
            ),
            Project(
                id: 2,
                name: "By client name",
                isPrivate: false,
                isActive: true,
                color: "#000000",
                billable: nil,
                workspaceId: mockUser.defaultWorkspace,
                clientId: 1
            )
        ]
    }

    private func tagsForAutocompletionTest() -> [Tag] {
        return [
            Tag(id: 0, name: "Matching", workspaceId: mockUser.defaultWorkspace),
            Tag(id: 1, name: "Not this one", workspaceId: mockUser.defaultWorkspace)
        ]
    }

    private func tasksForAutocompletionTest() -> [Task] {
        return [
            Task(
                id: 0,
                name: "Matching",
                active: true,
                estimatedSeconds: 0,
                trackedSeconds: 0,
                projectId: 1,
                workspaceId: mockUser.defaultWorkspace,
                userId: nil
            ),
            Task(
                id: 1,
                name: "Nope",
                active: true,
                estimatedSeconds: 0,
                trackedSeconds: 0,
                projectId: 1,
                workspaceId: mockUser.defaultWorkspace,
                userId: nil
            )
        ]
    }

    private func timeEntriesForAutocompletionTest() -> [TimeEntry] {
        let duration = 6000.0
        let startTime =  mockTime.now().addingTimeInterval(-duration)
        return [
            timeEntryMatchByName(startTime, duration),
            timeEntryMatchByProjectName(startTime, duration),
            timeEntryMatchByClientName(startTime, duration),
            timeEntryMatchByTagName(startTime, duration),
            timeEntryMatchByTaskName(startTime, duration),
            timeEntryDontMatchByName(startTime, duration),
            timeEntryDontMatchByProjectName(startTime, duration),
            timeEntryDontMatchByTagName(startTime, duration),
            timeEntryDontMatchByTaskName(startTime, duration)
        ]
    }

    private func timeEntryMatchByName(_ startTime: Date, _ duration: Double) -> TimeEntry {
        return TimeEntry(
            id: 0,
            description: "Matching",
            start: startTime,
            duration: duration,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )
    }

    private func timeEntryMatchByProjectName(_ startTime: Date, _ duration: Double) -> TimeEntry {
        var timeEntry = TimeEntry(
            id: 1,
            description: "By project name",
            start: startTime,
            duration: duration,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )
        timeEntry.projectId = 0
        return timeEntry
    }

    private func timeEntryMatchByClientName(_ startTime: Date, _ duration: Double) -> TimeEntry {
        var timeEntry = TimeEntry(
            id: 2,
            description: "By client name",
            start: startTime,
            duration: duration,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )
        timeEntry.projectId = 2
        return timeEntry
    }

    private func timeEntryMatchByTagName(_ startTime: Date, _ duration: Double) -> TimeEntry {
        var timeEntry = TimeEntry(
            id: 3,
            description: "By tag name",
            start: startTime,
            duration: duration,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )
        timeEntry.tagIds = [0]
        return timeEntry
    }

    private func timeEntryMatchByTaskName(_ startTime: Date, _ duration: Double) -> TimeEntry {
        var timeEntry = TimeEntry(
            id: 4,
            description: "By task name",
            start: startTime,
            duration: duration,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )
        timeEntry.taskId = 0
        return timeEntry
    }

    private func timeEntryDontMatchByName(_ startTime: Date, _ duration: Double) -> TimeEntry {
        return TimeEntry(
            id: 5,
            description: "Nope",
            start: startTime,
            duration: duration,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )
    }

    private func timeEntryDontMatchByProjectName(_ startTime: Date, _ duration: Double) -> TimeEntry {
        var timeEntry = TimeEntry(
            id: 6,
            description: "Nope",
            start: startTime,
            duration: duration,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )
        timeEntry.projectId = 1
        return timeEntry
    }

    private func timeEntryDontMatchByTagName(_ startTime: Date, _ duration: Double) -> TimeEntry {
        var timeEntry = TimeEntry(
            id: 7,
            description: "By client name",
            start: startTime,
            duration: duration,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )
        timeEntry.tagIds = [1]
        return timeEntry
    }

    private func timeEntryDontMatchByTaskName(_ startTime: Date, _ duration: Double) -> TimeEntry {
        var timeEntry = TimeEntry(
            id: 8,
            description: "By task name",
            start: startTime,
            duration: duration,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )
        timeEntry.taskId = 1
        return timeEntry
    }
}
