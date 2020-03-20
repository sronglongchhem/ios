import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

func createStartEditReducer(repository: Repository, time: Time) -> Reducer<StartEditState, StartEditAction> {
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
                start: time.now(),
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
            fatalError(error.description)
        }
    }
}

func startTimeEntry(_ timeEntry: TimeEntry, repository: Repository) -> Effect<StartEditAction> {
    return repository.addTimeEntry(timeEntry: timeEntry)
        .toEffect(
            map: { StartEditAction.timeEntryAdded(timeEntry) },
            catch: { StartEditAction.setError($0.toErrorType()) })
}
