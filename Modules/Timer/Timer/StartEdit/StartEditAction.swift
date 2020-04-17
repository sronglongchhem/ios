import Foundation
import Models

public enum StartEditAction: Equatable {
    case descriptionEntered(String)
    case closeButtonTapped
    case dialogDismissed
    case doneButtonTapped
    case timeEntryStarted(startedTimeEntry: TimeEntry, stoppedTimeEntry: TimeEntry?)
    case timeEntryUpdated(TimeEntry)

    case setError(ErrorType)
    case autocompleteSuggestionsUpdated([AutocompleteSuggestionType])
}

extension StartEditAction: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
            
        case let .descriptionEntered(description):
            return "DescriptionEntered \(description)"

        case .closeButtonTapped:
            return "CloseButtonTapped"

        case .dialogDismissed:
            return "DialogDismissed"

        case .doneButtonTapped:
            return "DoneButtonTapped"

        case let .timeEntryStarted(startedTimeEntry, stoppedTimeEntry):
            return "TimeEntryStarted: \(startedTimeEntry.description) stopped: \(stoppedTimeEntry?.description ?? "nil")"
            
        case let.timeEntryUpdated(timeEntry):
            return "TimeEntryUpdated: \(timeEntry.description)"
            
        case let .setError(error):
            return "SetError: \(error)"

        case let .autocompleteSuggestionsUpdated(suggestions):
            return "AutocompleteSuggestionsUpdated \(suggestions)"
        }
    }
}
