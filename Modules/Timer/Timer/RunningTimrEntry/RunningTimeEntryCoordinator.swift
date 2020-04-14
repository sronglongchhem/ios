import Foundation
import Architecture

public final class RunningTimeEntryCoordinator: BaseCoordinator {
    private var store: Store<RunningTimeEntryState, RunningTimeEntryAction>

    public init(store: Store<RunningTimeEntryState, RunningTimeEntryAction>) {
        self.store = store
    }

    public override func start() {
        let viewController = RunningTimeEntryViewController.instantiate()
        viewController.store = store
        self.rootViewController = viewController
    }
}
