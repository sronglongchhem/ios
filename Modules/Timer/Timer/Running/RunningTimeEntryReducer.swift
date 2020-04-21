import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

func createRunningTimeEntryReducer(repository: TimeLogRepository, time: Time) -> Reducer<RunningTimeEntryState, RunningTimeEntryAction> {
    return Reducer { state, action in
        switch action {
        case .cardTapped:
            if let runningTimeEntryId = runningTimeEntryViewModelSelector(state)?.id {
                guard let runningTimeEntry = state.entities.timeEntries[runningTimeEntryId]
                else { return [] }

                state.editableTimeEntry = EditableTimeEntry.fromSingle(runningTimeEntry)
                return []
            }

            guard case let Loadable.loaded(user) = state.user else { return [] }
            state.editableTimeEntry = EditableTimeEntry.empty(workspaceId: user.defaultWorkspace)

            return []
            
        case .startButtonTapped:
            guard state.runningTimeEntry == nil, let workspaceId = state.user.value?.defaultWorkspace else { return [] }
            let timeEntryDto = StartTimeEntryDto(workspaceId: workspaceId, description: "")
            return [startTimeEntryEffect(timeEntryDto, repository: repository)]

        case .timeEntryStarted(started: let started, stopped: let stopped):
            state.entities.timeEntries[started.id] = started
            if let stoppedTimeEntry = stopped {
                state.entities.timeEntries[stoppedTimeEntry.id] = stoppedTimeEntry
            }
            return []

        case let .setError(error):
            fatalError(error.description)
        }
    }
}

func startTimeEntryEffect(_ timeEntry: StartTimeEntryDto, repository: TimeLogRepository) -> Effect<RunningTimeEntryAction> {
    return repository
        .startTimeEntry(timeEntry)
        .toEffect(map: RunningTimeEntryAction.timeEntryStarted,
                  catch: { error in RunningTimeEntryAction.setError(error.toErrorType()) })
}
