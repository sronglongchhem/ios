import Foundation
import Architecture

class ProjectFeature: BaseFeature<ProjectState, ProjectAction> {
    override func mainCoordinator(store: Store<ProjectState, ProjectAction>) -> Coordinator {
        return ProjectCoordinator(store: store)
    }
}
