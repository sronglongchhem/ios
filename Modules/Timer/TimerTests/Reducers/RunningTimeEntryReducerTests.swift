import XCTest
import Architecture
import Models
import OtherServices
@testable import Timer

class RunningTimeEntryReducerTests: XCTestCase {

    var now = Date(timeIntervalSince1970: 987654321)
    var mockRepository: MockTimeLogRepository!
    var mockTime: Time!
    var mockUser: User!
    var reducer: Reducer<RunningTimeEntryState, RunningTimeEntryAction>!

    override func setUp() {
        mockTime = Time(getNow: { return self.now })
        mockRepository = MockTimeLogRepository(time: mockTime)
        mockUser = User(id: 0, apiToken: "token", defaultWorkspace: 0)

        reducer = createRunningTimeEntryReducer(repository: mockRepository, time: mockTime)
    }

    func testCardTappedWithRunningEntry() {

        let runningEntry = TimeEntry(id: 0, description: "", start: mockTime.now() - 1000, duration: nil, billable: false, workspaceId: 0)

        var entities = TimeLogEntities()
        entities.timeEntries[runningEntry.id] = runningEntry

        let state = RunningTimeEntryState(
            user: Loadable.loaded(mockUser),
            entities: entities,
            editableTimeEntry: nil
        )

        let expectedEditableEntry = EditableTimeEntry.fromSingle(runningEntry)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, RunningTimeEntryAction.cardTapped) {
                $0.editableTimeEntry = expectedEditableEntry
            }
        )
    }

    func testCardTappedWithoutRunningEntry() {

        let state = RunningTimeEntryState(
            user: Loadable.loaded(mockUser),
            entities: TimeLogEntities(),
            editableTimeEntry: nil
        )

        let expectedEditableEntry = EditableTimeEntry.empty(workspaceId: mockUser.defaultWorkspace)

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, RunningTimeEntryAction.cardTapped) {
                $0.editableTimeEntry = expectedEditableEntry
            }
        )
    }
}
