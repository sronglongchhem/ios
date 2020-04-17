import UIKit
import Architecture

public final class StartEditCoordinator: BaseCoordinator {
    private var store: Store<StartEditState, StartEditAction>
        
    public init(store: Store<StartEditState, StartEditAction>) {
        self.store = store
    }
    
    public override func start() {
        let startEditViewController = StartEditViewController.instantiate()
        startEditViewController.store = store

        let sheetController = StartEditBottomSheet(viewController: startEditViewController)
        sheetController.store = store

        self.rootViewController = sheetController
    }
}
