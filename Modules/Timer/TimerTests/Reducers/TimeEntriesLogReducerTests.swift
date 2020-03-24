import XCTest
import Architecture
import Models
import OtherServices
import RxBlocking
@testable import Timer

class TimeEntriesLogReducerTests: XCTestCase {

    var now = Date(timeIntervalSince1970: 987654321)
    var mockRepository: MockTimeLogRepository = MockTimeLogRepository()
    lazy var mockTime = { Time(getNow: { return self.now }) }()
    var reducer: Reducer<[Int: TimeEntry], TimeEntriesLogAction>!
    
    override func setUp() {
        reducer = createTimeEntriesLogReducer(repository: mockRepository, time: mockTime)
    }

    func testContinueTappedHappyFlow() {
        
        var state = [Int: TimeEntry]()
        state[0] = TimeEntry.with(id: 0, start: now.addingTimeInterval(-100), duration: 100)
        
        var expectedNewTimeEntry = state[0]!
        expectedNewTimeEntry.id = mockRepository.newTimeEntryId
        expectedNewTimeEntry.start = now
        expectedNewTimeEntry.duration = 0
        
        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .continueButtonTapped(0)),
            Step(.receive, .timeEntryStarted(expectedNewTimeEntry, nil)) {
                $0[expectedNewTimeEntry.id] = expectedNewTimeEntry
            }
        )
    }
    
    func testContinueTappedStoppingPreviousFlow() {
        
        var state = [Int: TimeEntry]()
        state[0] = TimeEntry.with(id: 0, start: now.addingTimeInterval(-200), duration: 100)
        state[1] = TimeEntry.with(id: 1, start: now.addingTimeInterval(-100), duration: 0)
        
        var expectedNewTimeEntry = state[0]!
        expectedNewTimeEntry.id = mockRepository.newTimeEntryId
        expectedNewTimeEntry.start = now
        expectedNewTimeEntry.duration = 0
        
        var expectedStoppedTimeEntry = state[1]!
        expectedStoppedTimeEntry.duration = 100
        
        mockRepository.stoppedTimeEntry = expectedStoppedTimeEntry
        
        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .continueButtonTapped(0)),
            Step(.receive, .timeEntryStarted(expectedNewTimeEntry, expectedStoppedTimeEntry)) {
                $0[expectedNewTimeEntry.id] = expectedNewTimeEntry
                $0[expectedStoppedTimeEntry.id] = expectedStoppedTimeEntry
            }
        )
    }
}
