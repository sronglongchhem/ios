import XCTest
import Architecture
import Models
import OtherServices
@testable import Timer

// swiftlint:disable type_body_length
class StartEditReducerTests: XCTestCase {
    var now = Date(timeIntervalSince1970: 987654321)
    var mockRepository: MockTimeLogRepository!
    var mockTime: Time!
    var mockUser: User!
    var reducer: Reducer<StartEditState, StartEditAction>!

    override func setUp() {
        mockTime = Time(getNow: { return self.now })
        mockRepository = MockTimeLogRepository(time: mockTime)
        mockUser = User(id: 0, apiToken: "token", defaultWorkspace: 0)

        reducer = createStartEditReducer(repository: mockRepository, time: mockTime)
    }

    func testDescriptionEntered() {

        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace),
            autocompleteSuggestions: []
        )

        let expectedDescription = "whatever"

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .descriptionEntered(expectedDescription)) {
                $0.editableTimeEntry?.description = expectedDescription
            }
        )
    }

    func testCloseButtonTapped() {

        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace),
            autocompleteSuggestions: []
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .closeButtonTapped) {
                $0.editableTimeEntry = nil
            }
        )
    }

    func testDialogDismissed() {

        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace),
            autocompleteSuggestions: []
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .dialogDismissed) {
                $0.editableTimeEntry = nil
            }
        )
    }

    func testDoneButtonTappedWhenTheresNoRunningEntry() {

        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: editableTimeEntry,
            autocompleteSuggestions: []
        )

        let expectedStartedEntry = TimeEntry(
            id: mockRepository.newTimeEntryId,
            description: editableTimeEntry.description,
            start: mockTime.now(),
            duration: nil,
            billable: editableTimeEntry.billable,
            workspaceId: mockUser.defaultWorkspace
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .doneButtonTapped),
            Step(.receive, .timeEntryStarted(startedTimeEntry: expectedStartedEntry, stoppedTimeEntry: nil)) {
                $0.editableTimeEntry = nil
                $0.entities.timeEntries[expectedStartedEntry.id] = expectedStartedEntry
            }
        )
    }

    func testDoneButtonTappedWhenTheresARunningEntry() {

        let runningTimeEntry = TimeEntry(
            id: 100,
            description: "Doing stuff",
            start: now.addingTimeInterval(-90),
            duration: nil,
            billable: false,
            workspaceId: mockUser.defaultWorkspace
        )

        var entities = TimeLogEntities()
        entities.timeEntries[runningTimeEntry.id] = runningTimeEntry
        mockRepository.stoppedTimeEntry = runningTimeEntry

        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
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
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, StartEditAction.doneButtonTapped),
            Step(.receive, StartEditAction.timeEntryStarted(startedTimeEntry: expectedStartedEntry, stoppedTimeEntry: runningTimeEntry)) {
                $0.editableTimeEntry = nil
                $0.entities.timeEntries[expectedStartedEntry.id] = expectedStartedEntry
        })
    }

    func testEnteringDescriptionAndThenPressingDone() {
        let entities = TimeLogEntities()
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let state = StartEditState(
            user: Loadable.loaded(mockUser),
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

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "h"),
            descriptionEnteredStep(for: "he"),
            descriptionEnteredStep(for: "hel"),
            descriptionEnteredStep(for: "hell"),
            descriptionEnteredStep(for: "hello"),
            Step(.send, StartEditAction.doneButtonTapped),
            Step(.receive, StartEditAction.timeEntryStarted(startedTimeEntry: expectedStartedEntry, stoppedTimeEntry: nil)) {
                $0.editableTimeEntry = nil
                $0.entities.timeEntries[expectedStartedEntry.id] = expectedStartedEntry
        })
    }
    
    func testAutocompleteSuggestionTapped() {
        
    }

    func testAutocompleteSuggestionsUpdatedUpdatesState() {
        let entities = TimeLogEntities()
        let editableTimeEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)
        let initialState = StartEditState(
            user: Loadable.loaded(mockUser),
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
    
    func testProjectButtonTappedNoSpaceAtTheEnd() {

        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace),
            autocompleteSuggestions: []
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "test with no space at the end"),
            Step(.send, .projectButtonTapped) { $0.editableTimeEntry?.description = "test with no space at the end @" }
        )
    }
    
    func testProjectButtonTappedASpaceAtTheEnd() {

        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace),
            autocompleteSuggestions: []
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "test with a space at the end "),
            Step(.send, .projectButtonTapped) { $0.editableTimeEntry?.description = "test with a space at the end @" }
        )
    }
    
    func testTagButtonTappedWithNoSpaceAtTheEnd() {

        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace),
            autocompleteSuggestions: []
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "test with no space at the end"),
            Step(.send, .tagButtonTapped) { $0.editableTimeEntry?.description = "test with no space at the end #" }
        )
    }
    
    func testTagButtonTappedWithASpaceAtTheEnd() {

        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace),
            autocompleteSuggestions: []
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            descriptionEnteredStep(for: "test with a space at the end "),
            Step(.send, .tagButtonTapped) { $0.editableTimeEntry?.description = "test with a space at the end #" }
        )
    }
    
    func testBillableButtonTapped() {

        let state = StartEditState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace),
            autocompleteSuggestions: []
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .billableButtonTapped) { $0.editableTimeEntry?.billable = true },
            Step(.send, .billableButtonTapped) { $0.editableTimeEntry?.billable = false }
        )
    }

    private func descriptionEnteredStep(for description: String) -> Step<StartEditState, StartEditAction> {
        return Step(.send, StartEditAction.descriptionEntered(description)) {
            $0.editableTimeEntry!.description = description
        }
    }
}
