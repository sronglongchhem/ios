import Foundation
import Architecture
import Models
import RxSwift
import Repository
import OtherServices

func createProjectReducer(repository: Repository) -> Reducer<ProjectState, ProjectAction> {
    return Reducer {_, _ -> [Effect<ProjectAction>] in
        return []
    }
}
