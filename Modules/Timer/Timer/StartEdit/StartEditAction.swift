import Foundation
import Models

public enum StartEditAction: Equatable {
    case descriptionEntered(String)
    case doneButtonTapped
    case timeEntryStarted(startedTimeEntry: TimeEntry, stoppedTimeEntry: TimeEntry?)
    case timeEntryUpdated(TimeEntry)
    case setError(ErrorType)
}

extension StartEditAction: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
       
        case let .descriptionEntered(description):
            return "DescriptionEntered \(description)"
            
        case .doneButtonTapped:
            return "DoneButtonTapped"
                        
        case let .timeEntryStarted(startedTimeEntry, stoppedTimeEntry):
            return "TimeEntryStarted: \(startedTimeEntry.description) stopped: \(stoppedTimeEntry?.description ?? "nil")"
            
        case let.timeEntryUpdated(timeEntry):
            return "TimeEntryUpdated: \(timeEntry.description)"
            
        case let .setError(error):
            return "SetError: \(error)"
        }
    }
}
