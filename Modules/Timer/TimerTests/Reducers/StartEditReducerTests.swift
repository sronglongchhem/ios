import XCTest
import Architecture
import Models
import OtherServices
import RxBlocking
@testable import Timer

class StartEditReducerTests: XCTestCase {
    let defaultWorkspaceId: Int64 = 10

    var now = Date(timeIntervalSince1970: 987654321)
    var mockRepository: MockTimeLogRepository!
    var mockTime: Time!
    var reducer: Reducer<StartEditState, StartEditAction>!
    var user: User!

    override func setUp() {
        mockTime = Time(getNow: { return self.now })
        mockRepository = MockTimeLogRepository(time: mockTime)
        reducer = createStartEditReducer(repository: mockRepository, time: mockTime)
        user = User(id: 1, apiToken: "SECRET", defaultWorkspace: defaultWorkspaceId)
    }

    func testPressingTheDoneButtonWhenEditableEntryIsEmpty() {
        let entities = TimeLogEntities()
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: user.defaultWorkspace)
        let initialState = StartEditState(
            user: Loadable.loaded(user),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [])

        let expectedStartedEntry = TimeEntry(
            id: mockRepository.newTimeEntryId,
            description: editableTimeEntry.description,
            start: mockTime.now(),
            duration: nil,
            billable: false,
            workspaceId: editableTimeEntry.workspaceId)

        assertReducerFlow(
            initialState: initialState,
            reducer: reducer,
            steps:
            Step(.send, StartEditAction.doneButtonTapped) {
                $0.editableTimeEntry = nil
            },
            Step(.receive, StartEditAction.timeEntryStarted(startedTimeEntry: expectedStartedEntry, stoppedTimeEntry: nil)) {
                $0.editableTimeEntry = nil
                $0.entities.timeEntries[expectedStartedEntry.id] = expectedStartedEntry
            })
    }

    func testPressingTheDoneButtonWhenEditableEntryIsEmptyAndAnEntryIsAlreadyRunning() {
        var entities = TimeLogEntities()
        let runningTimeEntry = TimeEntry(
            id: 100,
            description: "Doing stuff",
            start: now.addingTimeInterval(-90),
            duration: nil,
            billable: false,
            workspaceId: user.defaultWorkspace)
        entities.timeEntries[runningTimeEntry.id] = runningTimeEntry
        mockRepository.stoppedTimeEntry = runningTimeEntry
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: user.defaultWorkspace)
        let initialState = StartEditState(
            user: Loadable.loaded(user),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [])

        let expectedStartedEntry = TimeEntry(
            id: mockRepository.newTimeEntryId,
            description: editableTimeEntry.description,
            start: mockTime.now(),
            duration: nil,
            billable: false,
            workspaceId: editableTimeEntry.workspaceId)

        assertReducerFlow(
            initialState: initialState,
            reducer: reducer,
            steps:
            Step(.send, StartEditAction.doneButtonTapped) {
                $0.editableTimeEntry = nil
            },
            Step(.receive, StartEditAction.timeEntryStarted(startedTimeEntry: expectedStartedEntry, stoppedTimeEntry: runningTimeEntry)) {
                $0.editableTimeEntry = nil
                $0.entities.timeEntries[expectedStartedEntry.id] = expectedStartedEntry
            })
    }

    func testEnteringDescriptionAndThenPressingDone() {
        let entities = TimeLogEntities()
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: user.defaultWorkspace)
        let initialState = StartEditState(
            user: Loadable.loaded(user),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [])

        let expectedStartedEntry = TimeEntry(
            id: mockRepository.newTimeEntryId,
            description: "hello",
            start: mockTime.now(),
            duration: nil,
            billable: false,
            workspaceId: editableTimeEntry.workspaceId)

        func descriptionEnteredStep(for description: String) -> Step<StartEditState, StartEditAction> {
            return Step(.send, StartEditAction.descriptionEntered(description)) {
                    $0.editableTimeEntry!.description = description
            }
        }
        assertReducerFlow(
            initialState: initialState,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "h"),
            descriptionEnteredStep(for: "he"),
            descriptionEnteredStep(for: "hel"),
            descriptionEnteredStep(for: "hell"),
            descriptionEnteredStep(for: "hello"),
            Step(.send, StartEditAction.doneButtonTapped) {
                $0.editableTimeEntry = nil
            },
            Step(.receive, StartEditAction.timeEntryStarted(startedTimeEntry: expectedStartedEntry, stoppedTimeEntry: nil)) {
                $0.editableTimeEntry = nil
                $0.entities.timeEntries[expectedStartedEntry.id] = expectedStartedEntry
            })
    }

    func testAutocompleteSuggestionsUpdatedUpdatesState() {
        let entities = TimeLogEntities()
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: user.defaultWorkspace)
        let initialState = StartEditState(
            user: Loadable.loaded(user),
            entities: entities,
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: [])

        let autocompleteSuggestions: [AutocompleteSuggestionType] = [
            .timeEntrySuggestion(timeEntry: TimeEntry.with(id: 0, start: now.addingTimeInterval(-300), duration: 100)),
            .timeEntrySuggestion(timeEntry: TimeEntry.with(id: 1, start: now.addingTimeInterval(-200), duration: 100))
        ]

        assertReducerFlow(
            initialState: initialState,
            reducer: reducer,
            steps:
            Step(.send, StartEditAction.autocompleteSuggestionsUpdated(autocompleteSuggestions)) {
                $0.autocompleteSuggestions = autocompleteSuggestions
            })
    }
}
