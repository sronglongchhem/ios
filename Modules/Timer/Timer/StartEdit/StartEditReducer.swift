import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

// swiftlint:disable cyclomatic_complexity function_body_length
func createStartEditReducer(repository: TimeLogRepository, time: Time) -> Reducer<StartEditState, StartEditAction> {
    return Reducer {state, action in
        
        switch action {
            
        case let .descriptionEntered(description, position):
            state.cursorPosition = position
            state.editableTimeEntry.description = description

            return updateAutocompleteSuggestionsEffect(description, position, state.entities, repository)

        case .closeButtonTapped, .dialogDismissed:
            return []

        case .doneButtonTapped:
            return doneButtonTapped(state, repository)

        case .timeEntryStarted:
            return []

        case .timeEntryUpdated:
            return []
            
        case let .autocompleteSuggestionTapped(suggestion):
            state.editableTimeEntry.setDetails(from: suggestion, and: state.cursorPosition)
            return []
            
        case let .dateTimePicked(date):
            dateTimePicked(&state, date: date)
            return []

        case let .pickerTapped(mode):
            state.dateTimePickMode = mode
            return []

        case .dateTimePickingCancelled:
            state.dateTimePickMode = .none
            return []

        case .billableButtonTapped:
            state.editableTimeEntry.billable.toggle()
            return []

        case let .autocompleteSuggestionsUpdated(suggestions):
            state.autocompleteSuggestions = suggestions
            return []
            
        case .projectButtonTapped, .addProjectChipTapped:
            state.editableTimeEntry.description = appendCharacter("@", toString: state.editableTimeEntry.description)
            return []
            
        case .tagButtonTapped, .addTagChipTapped:
            state.editableTimeEntry.description = appendCharacter("#", toString: state.editableTimeEntry.description)
            return []

        case let .durationInputted(duration):
            guard duration >= 0, !state.editableTimeEntry.isGroup else { return[] }
            if state.editableTimeEntry.isRunningOrNew {
                let newStartTime = time.now() - duration
                state.editableTimeEntry.start = newStartTime
            } else {
                state.editableTimeEntry.duration = duration
            }
            return []
        case let .setError(error):
            fatalError(error.description)
        }
    }
}

func startTimeEntry(_ timeEntry: StartTimeEntryDto, repository: TimeLogRepository) -> Effect<StartEditAction> {
    return repository
        .startTimeEntry(timeEntry)
        .toEffect(map: StartEditAction.timeEntryStarted ,
                  catch: { error in StartEditAction.setError(error.toErrorType()) })
}

func doneButtonTapped(_ state: StartEditState, _ repository: TimeLogRepository) -> [Effect<StartEditAction>] {
    let shouldStartNewTimeEntry = state.editableTimeEntry.ids.isEmpty
    if shouldStartNewTimeEntry {
        return [startTimeEntry(state.editableTimeEntry.toStartTimeEntryDto(), repository: repository)]
    }

    let updatedTimeEnries = state.editableTimeEntry.ids
        .map { state.entities.getTimeEntry($0) }
        .filter { $0 != nil }
        .map { $0!.with(
            description: state.editableTimeEntry.description,
            billable: state.editableTimeEntry.billable
        )}

    persistUpdatedTimeEntries(updatedTimeEnries)
    return []
}

func dateTimePicked(_ state: inout StartEditState, date: Date) {
    if state.dateTimePickMode == .start {
        state.editableTimeEntry.start = date
    } else if state.dateTimePickMode == .end && state.editableTimeEntry.start != nil {
        state.editableTimeEntry.duration = date.timeIntervalSince(state.editableTimeEntry.start!)
    }
}

func persistUpdatedTimeEntries(_ timeEntries: [TimeEntry]) {
    //repository.update()
}

func appendCharacter( _ character: String, toString string: String) -> String {
    var stringToAppend = character
    if let lastChar = string.last, lastChar != " " {
        stringToAppend = " " + stringToAppend
    }
    return string + stringToAppend
}

extension EditableTimeEntry {
    mutating func setDetails(from suggestion: AutocompleteSuggestion, and cursorPosition: Int) {
        switch suggestion {
        case .timeEntrySuggestion(let timeEntry):
            workspaceId = timeEntry.workspaceId
            description = timeEntry.description
            projectId = timeEntry.projectId
            tagIds = timeEntry.tagIds
            taskId = timeEntry.taskId
            billable = timeEntry.billable
        case .projectSuggestion(let project):
            projectId = project.id
            workspaceId = project.workspaceId

            let (optionalToken, currentQuery) = description.findTokenAndQueryMatchesForAutocomplete("@", cursorPosition)
            guard let token = optionalToken else { return }
            let delimiter = "\(String(token))\(currentQuery)"
            guard let rangeToReplace = description.range(of: delimiter) else { return }
            let newDescription = description.replacingCharacters(in: rangeToReplace, with: "")
            description = newDescription
        case .taskSuggestion:
            fatalError()
        case .tagSuggestion:
            fatalError()
        case .createProjectSuggestion:
            fatalError()
        case .createTagSuggestion:
            fatalError()
        }
    }
}
