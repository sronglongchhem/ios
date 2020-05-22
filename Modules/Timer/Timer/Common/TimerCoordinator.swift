import UIKit
import Architecture

public final class TimerCoordinator: BaseCoordinator {

    private var store: Store<TimerState, TimerAction>

    private let timeLogCoordinator: TimeEntriesLogCoordinator
    private let startEditCoordinator: StartEditCoordinator
    private let runningTimeEntryCoordinator: RunningTimeEntryCoordinator
//    private let projectCoordinator: ProjectCoordinator

    public init(
        store: Store<TimerState, TimerAction>,
        timeLogCoordinator: TimeEntriesLogCoordinator,
        startEditCoordinator: StartEditCoordinator,
        runningTimeEntryCoordinator: RunningTimeEntryCoordinator
//        ,
//        projectCoordinator: ProjectCoordinator
    ) {
        self.store = store
        self.timeLogCoordinator = timeLogCoordinator
        self.startEditCoordinator = startEditCoordinator
        self.runningTimeEntryCoordinator = runningTimeEntryCoordinator
//        self.projectCoordinator = projectCoordinator
    }

    public override func start() {
        timeLogCoordinator.start()
        startEditCoordinator.start()
        runningTimeEntryCoordinator.start()
        let viewController = TimerViewController()
        viewController.timeLogViewController = timeLogCoordinator.rootViewController
        viewController.startEditBottomSheet = startEditCoordinator.rootViewController as? StartEditBottomSheet<StartEditViewController>
        viewController.runningTimeEntryViewController = runningTimeEntryCoordinator.rootViewController as? RunningTimeEntryViewController
        self.rootViewController = viewController
    }
}
