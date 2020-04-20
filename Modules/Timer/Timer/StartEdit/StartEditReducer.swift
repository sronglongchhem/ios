import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

// swiftlint:disable cyclomatic_complexity
func createStartEditReducer(repository: TimeLogRepository, time: Time) -> Reducer<StartEditState, StartEditAction> {
    return Reducer {state, action in
        
        switch action {
            
        case let .descriptionEntered(description):
            if state.editableTimeEntry != nil {
                state.editableTimeEntry!.description = description
            }
            return []

        case .closeButtonTapped, .dialogDismissed:
            state.editableTimeEntry = nil
            return []

        case .doneButtonTapped:
            return doneButtonTapped(state, repository)

        case let .timeEntryStarted(startedTimeEntry, stoppedTimeEntry):
            state.editableTimeEntry = nil
            state.entities.timeEntries[startedTimeEntry.id] = startedTimeEntry
            if let stoppedTimeEntry = stoppedTimeEntry {
                state.entities.timeEntries[stoppedTimeEntry.id] = stoppedTimeEntry
            }
            return []

        case let .timeEntryUpdated(timeEntry):
            state.entities.timeEntries[timeEntry.id] = timeEntry
            state.editableTimeEntry = nil
            return []
            
        case .billableButtonTapped:
            guard let editableTimeEntry = state.editableTimeEntry else { return [] }
            state.editableTimeEntry?.billable = !editableTimeEntry.billable
            return []

        case let .autocompleteSuggestionsUpdated(suggestions):
            state.autocompleteSuggestions = suggestions
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
    let editableTimeEntry = state.editableTimeEntry!
    let shouldStartNewTimeEntry = editableTimeEntry.ids.isEmpty
    if shouldStartNewTimeEntry {
        return [startTimeEntry(editableTimeEntry.toStartTimeEntryDto(), repository: repository)]
    }

    let updatedTimeEnries = editableTimeEntry.ids
        .map { state.entities.getTimeEntry($0) }
        .filter { $0 != nil }
        .map { $0!.with(
            description: editableTimeEntry.description,
            billable: editableTimeEntry.billable) }

    persistUpdatedTimeEntries(updatedTimeEnries)
    return []
}

func persistUpdatedTimeEntries(_ timeEntries: [TimeEntry]) {
    //repository.update()
}
