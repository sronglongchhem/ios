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
        }
    }
}
