import XCTest
import Architecture
import Models
import OtherServices
@testable import Timer

class ProjectReducerTests: XCTestCase {
    var now = Date(timeIntervalSince1970: 987654321)
    var mockRepository: MockTimeLogRepository!
    var mockTime: Time!
    var mockUser: User!
    var reducer: Reducer<ProjectState, ProjectAction>!

    override func setUp() {
        mockTime = Time(getNow: { return self.now })
        mockRepository = MockTimeLogRepository(time: mockTime)
        mockUser = User(id: 0, apiToken: "token", defaultWorkspace: 0)
        
        reducer = createProjectReducer(repository: mockRepository)
    }

    func testNameEntered() {

        let state = ProjectState(
            editableProject: EditableProject.empty(workspaceId: mockUser.defaultWorkspace),
            projects: [:]
        )

        let expectedName = "potato"

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .nameEntered(expectedName)) {
                $0.editableProject?.name = expectedName
            }
        )
    }

    func testTogglePrivateProject() {
        let state = ProjectState(
            editableProject: EditableProject.empty(workspaceId: mockUser.defaultWorkspace),
            projects: [:]
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .privateProjectSwitchTapped) {
                $0.editableProject?.isPrivate = false
            },
            Step(.send, .privateProjectSwitchTapped) {
                $0.editableProject?.isPrivate = true
            }
        )
    }
}
