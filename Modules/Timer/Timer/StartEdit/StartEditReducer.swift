import Foundation
import Architecture
import Models
import RxSwift
import Repository

func createStartEditReducer(repository: Repository) -> Reducer<StartEditState, StartEditAction> {
    return Reducer {state, action in
        
        switch action {
            
        case let .descriptionEntered(description):
            state.description = description
            return []
            
        case .startTapped:
            guard let defaultWorkspace = state.user.value?.defaultWorkspace else {
                fatalError("No default workspace")
            }
            
            let timeEntry = TimeEntry(
                id: state.entities.timeEntries.count,
                description: state.description,
                start: Date(),
                duration: -1,
                billable: false,
                workspaceId: defaultWorkspace
            )
            
            state.description = ""
            return [
                startTimeEntry(timeEntry, repository: repository)
            ]
            
        case let .timeEntryAdded(timeEntry):
            state.entities.timeEntries[timeEntry.id] = timeEntry
            return []
            
        case let .setError(error):
            state.entities.loading = .error(error)
            return []
        }
    }
}

func startTimeEntry(_ timeEntry: TimeEntry, repository: Repository) -> Effect<StartEditAction> {
    return repository.addTimeEntry(timeEntry: timeEntry)
        .toEffect(
            map: { StartEditAction.timeEntryAdded(timeEntry) },
            catch: { StartEditAction.setError($0) })
}
