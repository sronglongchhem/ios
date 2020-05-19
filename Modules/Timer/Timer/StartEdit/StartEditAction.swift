import Foundation
import Models

public enum StartEditAction: Equatable {
    case durationInputted(TimeInterval)
    case descriptionEntered(String, Int)
    case closeButtonTapped
    case dialogDismissed
    case doneButtonTapped
    case timeEntryStarted(startedTimeEntry: TimeEntry, stoppedTimeEntry: TimeEntry?)
    case timeEntryUpdated(TimeEntry)
    
    case autocompleteSuggestionTapped(AutocompleteSuggestion)
    
    case dateTimePicked(Date)
    case pickerTapped(DateTimePickMode)
    case dateTimePickingCancelled

    case projectButtonTapped
    case addProjectChipTapped
    case tagButtonTapped
    case addTagChipTapped
    case billableButtonTapped

    case setError(ErrorType)
    case autocompleteSuggestionsUpdated([AutocompleteSuggestion])
}

extension StartEditAction: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        switch self {
            
        case let .descriptionEntered(description, position):
            return "DescriptionEntered \(description), cursor position \(position)"

        case .closeButtonTapped:
            return "CloseButtonTapped"

        case .dialogDismissed:
            return "DialogDismissed"

        case .doneButtonTapped:
            return "DoneButtonTapped"

        case let .timeEntryStarted(startedTimeEntry, stoppedTimeEntry):
            return "TimeEntryStarted: \(startedTimeEntry.description) stopped: \(stoppedTimeEntry?.description ?? "nil")"
            
        case let .timeEntryUpdated(timeEntry):
            return "TimeEntryUpdated: \(timeEntry.description)"
            
        case let .autocompleteSuggestionTapped(suggestion):
            return "AutocompleteSuggestionTapped \(suggestion)"
            
        case let .dateTimePicked(date):
            return "dateTimePicked \(date)"

        case let .pickerTapped(mode):
            return "pickerTakked \(mode)"

        case .dateTimePickingCancelled:
            return "DateTimePickingCancelled"

        case .billableButtonTapped:
            return "BillableButtonTapped"
            
        case .tagButtonTapped:
            return "TagButtonTapped"

        case .addTagChipTapped:
            return "AddTagChipTapped"
            
        case .projectButtonTapped:
            return "ProjectButtonTapped"

        case .addProjectChipTapped:
            return "AddProjectButtonTapped"
            
        case let .setError(error):
            return "SetError: \(error)"

        case let .autocompleteSuggestionsUpdated(suggestions):
            return "AutocompleteSuggestionsUpdated \(suggestions)"

        case let .durationInputted(duration):
            return ".durationInputted \(duration)"
        }
    }
}
