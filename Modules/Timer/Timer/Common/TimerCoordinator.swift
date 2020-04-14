import UIKit
import Architecture

public final class TimerCoordinator: BaseCoordinator {

    private var store: Store<TimerState, TimerAction>

    private let timeLogCoordinator: TimeEntriesLogCoordinator
    private let startEditCoordinator: StartEditCoordinator
    private let runningTimeEntryCoordinator: RunningTimeEntryCoordinator

    public init(store: Store<TimerState, TimerAction>,
                timeLogCoordinator: TimeEntriesLogCoordinator,
                startEditCoordinator: StartEditCoordinator,
                runningTimeEntryCoordinator: RunningTimeEntryCoordinator) {
        self.store = store
        self.timeLogCoordinator = timeLogCoordinator
        self.startEditCoordinator = startEditCoordinator
        self.runningTimeEntryCoordinator = runningTimeEntryCoordinator
    }

    public override func start() {
        timeLogCoordinator.start()
        startEditCoordinator.start()
        runningTimeEntryCoordinator.start()
        let viewController = TimerViewController()
        viewController.timeLogViewController = timeLogCoordinator.rootViewController
        viewController.startEditViewController = startEditCoordinator.rootViewController as? StartEditViewController
        viewController.runningTimeEntryViewController = runningTimeEntryCoordinator.rootViewController as? RunningTimeEntryViewController
        self.rootViewController = viewController
    }
}
