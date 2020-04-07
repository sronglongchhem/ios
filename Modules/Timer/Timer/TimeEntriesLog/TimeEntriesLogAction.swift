import Foundation
import Models

public enum SwipeDirection {
    case left
    case right
}

public enum TimeEntriesLogAction: Equatable {
    case continueButtonTapped(Int64)
    case timeEntrySwiped(SwipeDirection, Int64)
    case timeEntryTapped(Int64)
    
    case toggleTimeEntryGroupTapped(Int)
    case timeEntryGroupSwiped(SwipeDirection, [Int64])
    
    case timeEntryDeleted(Int64)
    case timeEntryStarted(TimeEntry, TimeEntry?)
    
    case setError(ErrorType)

    case commitDeletion(Set<Int64>)
}

extension TimeEntriesLogAction: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
            
        case let .continueButtonTapped(timeEntryId):
            return "ContinueButtonTapped: \(timeEntryId)"
       
        case let .timeEntrySwiped(direction, timeEntryId):
            return "TimeEntrySwiped \(direction): \(timeEntryId)"
            
        case let .timeEntryTapped(timeEntryId):
            return "TimeEntryTapped: \(timeEntryId)"
            
        case let .toggleTimeEntryGroupTapped(groupId):
            return "ToggleTimeEntryGroupTapped: \(groupId)"
            
        case let .timeEntryGroupSwiped(direction, timeEntryIds):
            return "TimeEntryGroupSwiped \(direction): \(timeEntryIds)"

        case let .timeEntryDeleted(timeEntryId):
            return "TimeEntryDeleted: \(timeEntryId)"

        case let .timeEntryStarted(startedTimeEntry, stoppedTimeEntry):
            return "TimeEntryStarted: \(startedTimeEntry.description), stopped: \(String(describing: stoppedTimeEntry?.description))"
            
        case let .setError(error):
            return "SetError: \(error)"

        case let .commitDeletion(timeEntryIds):
            return "CommitDeletion: \(timeEntryIds)"
        }
    }
}
