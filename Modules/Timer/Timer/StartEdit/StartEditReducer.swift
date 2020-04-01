import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

func createStartEditReducer(repository: TimeLogRepository, time: Time) -> Reducer<StartEditState, StartEditAction> {
    return Reducer {state, action in
        
        switch action {
            
        case let .descriptionEntered(description):
            if state.editableTimeEntry != nil {
                state.editableTimeEntry!.description = description
            }
            return []
            
        case .startTapped:
            guard let defaultWorkspaceId = state.user.value?.defaultWorkspace else {
                fatalError("No default workspace")
            }
          
            state.editableTimeEntry = EditableTimeEntry.empty(workspaceId: defaultWorkspaceId)
            
            return [
                startTimeEntry(state.editableTimeEntry!.toStartTimeEntryDto(), repository: repository)
            ]
            
        case let .timeEntryAdded(timeEntry):
            state.entities.timeEntries[timeEntry.id] = timeEntry
            return []
            
        case let .setError(error):
            fatalError(error.description)
        }
    }
}

func startTimeEntry(_ timeEntry: StartTimeEntryDto, repository: TimeLogRepository) -> Effect<StartEditAction> {
    return repository
        .startTimeEntry(timeEntry)
        .toEffect(map: { (started, _) in StartEditAction.timeEntryAdded(started) },
                  catch: { error in StartEditAction.setError(error.toErrorType()) })
}
