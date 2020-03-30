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
    var reducer: Reducer<TimeEntriesLogState, TimeEntriesLogAction>!
    
    override func setUp() {
        reducer = createTimeEntriesLogReducer(repository: mockRepository, time: mockTime)
    }

    func testContinueTappedHappyFlow() {
        
        var timeEntries = [Int64: TimeEntry]()
        timeEntries[0] = TimeEntry.with(id: 0, start: now.addingTimeInterval(-100), duration: 100)
        
        var expectedNewTimeEntry = timeEntries[0]!
        expectedNewTimeEntry.id = mockRepository.newTimeEntryId
        expectedNewTimeEntry.start = now
        expectedNewTimeEntry.duration = nil
        
        var entities = TimeLogEntities()
        entities.timeEntries = timeEntries
        let state = TimeEntriesLogState(entities: entities, expandedGroups: [])
        
        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .continueButtonTapped(0)),
            Step(.receive, .timeEntryStarted(expectedNewTimeEntry, nil)) {
                $0.entities.timeEntries[expectedNewTimeEntry.id] = expectedNewTimeEntry
            }
        )
    }
    
    func testContinueTappedStoppingPreviousFlow() {
        
        var timeEntries = [Int64: TimeEntry]()
        timeEntries[0] = TimeEntry.with(id: 0, start: now.addingTimeInterval(-200), duration: 100)
        timeEntries[1] = TimeEntry.with(id: 1, start: now.addingTimeInterval(-100), duration: 0)
                
        var expectedNewTimeEntry = timeEntries[0]!
        expectedNewTimeEntry.id = mockRepository.newTimeEntryId
        expectedNewTimeEntry.start = now
        expectedNewTimeEntry.duration = nil
        
        var expectedStoppedTimeEntry = timeEntries[1]!
        expectedStoppedTimeEntry.duration = 100
        
        mockRepository.stoppedTimeEntry = expectedStoppedTimeEntry
        
        var entities = TimeLogEntities()
        entities.timeEntries = timeEntries
        let state = TimeEntriesLogState(entities: entities, expandedGroups: [])
        
        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .continueButtonTapped(0)),
            Step(.receive, .timeEntryStarted(expectedNewTimeEntry, expectedStoppedTimeEntry)) {
                $0.entities.timeEntries[expectedNewTimeEntry.id] = expectedNewTimeEntry
                $0.entities.timeEntries[expectedStoppedTimeEntry.id] = expectedStoppedTimeEntry
            }
        )
    }
    
    func testTimeEntrySwipedLeftHappyFlow() {
        
        let swipedTimeEntryId: Int64 = 0
        
        var timeEntries = [Int64: TimeEntry]()
        timeEntries[0] = TimeEntry.with(id: 0, start: now.addingTimeInterval(-200), duration: 100)
        timeEntries[1] = TimeEntry.with(id: 1, start: now.addingTimeInterval(-100), duration: 200)

        var entities = TimeLogEntities()
        entities.timeEntries = timeEntries
        let state = TimeEntriesLogState(entities: entities, expandedGroups: [])
        
        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .timeEntrySwiped(.left, swipedTimeEntryId)),
            Step(.receive, .timeEntryDeleted(swipedTimeEntryId)) {
                $0.entities.timeEntries[swipedTimeEntryId] = nil
            }
        )
    }
    
    func testTimeEntrySwipedRightHappyFlow() {
        
        let swipedTimeEntryId: Int64 = 0
        
        var timeEntries = [Int64: TimeEntry]()
        timeEntries[0] = TimeEntry.with(id: 0, start: now.addingTimeInterval(-200), duration: 100)
        timeEntries[1] = TimeEntry.with(id: 1, start: now.addingTimeInterval(-100), duration: 200)
        
        var expectedNewTimeEntry = timeEntries[0]!
        expectedNewTimeEntry.id = mockRepository.newTimeEntryId
        expectedNewTimeEntry.start = now
        expectedNewTimeEntry.duration = nil

        var entities = TimeLogEntities()
        entities.timeEntries = timeEntries
        let state = TimeEntriesLogState(entities: entities, expandedGroups: [])

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .timeEntrySwiped(.right, swipedTimeEntryId)),
            Step(.receive, .timeEntryStarted(expectedNewTimeEntry, nil)) {
                $0.entities.timeEntries[expectedNewTimeEntry.id] = expectedNewTimeEntry
            }
        )
    }
    
    func testTimeEntrySwipedRightWithRunningEntry() {
        
        let swipedTimeEntryId: Int64 = 0
        
        var timeEntries = [Int64: TimeEntry]()
        timeEntries[0] = TimeEntry.with(id: 0, start: now.addingTimeInterval(-200), duration: 100)
        timeEntries[1] = TimeEntry.with(id: 1, start: now.addingTimeInterval(-100), duration: 0)
        
        var expectedNewTimeEntry = timeEntries[0]!
        expectedNewTimeEntry.id = mockRepository.newTimeEntryId
        expectedNewTimeEntry.start = now
        expectedNewTimeEntry.duration = nil
        
        var expectedStoppedTimeEntry = timeEntries[1]!
        expectedStoppedTimeEntry.duration = 100
        
        mockRepository.stoppedTimeEntry = expectedStoppedTimeEntry
        
        var entities = TimeLogEntities()
        entities.timeEntries = timeEntries
        let state = TimeEntriesLogState(entities: entities, expandedGroups: [])

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .timeEntrySwiped(.right, swipedTimeEntryId)),
            Step(.receive, .timeEntryStarted(expectedNewTimeEntry, expectedStoppedTimeEntry)) {
                $0.entities.timeEntries[expectedNewTimeEntry.id] = expectedNewTimeEntry
                $0.entities.timeEntries[expectedStoppedTimeEntry.id] = expectedStoppedTimeEntry
            }
        )
    }
    
    func testTimeEntryTapped() {
        
        let timeEntryTappedId: Int64 = 0
        
        var timeEntries = [Int64: TimeEntry]()
        timeEntries[0] = TimeEntry.with(id: 0, start: now.addingTimeInterval(-200), duration: 100)
        timeEntries[1] = TimeEntry.with(id: 1, start: now.addingTimeInterval(-100), duration: 200)

        var entities = TimeLogEntities()
        entities.timeEntries = timeEntries
        let state = TimeEntriesLogState(entities: entities, expandedGroups: [])

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, .timeEntryTapped(timeEntryTappedId))
            // This tests this action does nothing for now. Fill the rest of the steps here
        )
    }
}
