import UIKit
import Architecture

public final class ProjectCoordinator: BaseCoordinator {
    private var store: Store<ProjectState, ProjectAction>

    public init(store: Store<ProjectState, ProjectAction>) {
        self.store = store
    }

    public override func start() {
        let viewController = ProjectViewController.instantiate()
        viewController.store = store
        self.rootViewController = viewController
    }
}
