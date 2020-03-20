import Foundation
import Models

public enum StartEditAction: Equatable {
    case descriptionEntered(String)
    case startTapped
    case timeEntryAdded(TimeEntry)
    case setError(ErrorType)
}

extension StartEditAction: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
       
        case let .descriptionEntered(description):
            return "DescriptionEntered \(description)"
            
        case .startTapped:
            return "StartTapped"
            
        case let .timeEntryAdded(timeEntry):
            return "TimeEntryAdded: \(timeEntry.description)"
                        
        case let .setError(error):
            return "SetError: \(error)"
        }
    }
}
