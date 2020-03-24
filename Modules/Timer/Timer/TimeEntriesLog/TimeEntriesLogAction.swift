import Foundation
import Models

public enum SwipeDirection {
    case left
    case right
}

public enum TimeEntriesLogAction: Equatable {
    case continueButtonTapped(Int)
    case timeEntrySwiped(SwipeDirection, Int)
    case timeEntryTapped(Int)
    
    case timeEntryDeleted(Int)
    case timeEntryStarted(TimeEntry, TimeEntry?)
    
    case setError(ErrorType)
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

        case let .timeEntryDeleted(timeEntryId):
            return "TimeEntryDeleted: \(timeEntryId)"

        case let .timeEntryStarted(startedTimeEntry, stoppedTimeEntry):
            return "TimeEntryStarted: \(startedTimeEntry.description), stopped: \(String(describing: stoppedTimeEntry?.description))"
            
        case let .setError(error):
            return "SetError: \(error)"
        }
    }
}
