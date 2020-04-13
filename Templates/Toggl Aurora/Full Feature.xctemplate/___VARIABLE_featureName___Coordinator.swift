import UIKit
import Architecture

public final class ___VARIABLE_featureName___Coordinator: BaseCoordinator {
    private var store: Store<___VARIABLE_featureName___State, ___VARIABLE_featureName___Action>

    public init(store: Store<___VARIABLE_featureName___State, ___VARIABLE_featureName___Action>) {
        self.store = store
    }

    public override func start() {
        let viewController = ___VARIABLE_featureName___ViewController.instantiate()
        viewController.store = store
        self.rootViewController = viewController
    }
}
