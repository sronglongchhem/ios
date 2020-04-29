import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

func createProjectReducer(repository: TimeLogRepository) -> Reducer<ProjectState, ProjectAction> {
    return Reducer { state, action in

        switch action {
        case .nameEntered(let name):
            state.editableProject?.name = name
            return []
        case .privateProjectSwitchTapped:
            state.editableProject?.isPrivate.toggle()
            return []
        }
    }
}
