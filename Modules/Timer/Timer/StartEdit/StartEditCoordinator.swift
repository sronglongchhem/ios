import UIKit
import Architecture

final class StartEditCoordinator: BaseCoordinator
{
    private var store: Store<StartEditState, StartEditAction>
        
    init(store: Store<StartEditState, StartEditAction>)
    {
        self.store = store
    }
    
    public override func start()
    {
        let vc = StartEditViewController.instantiate()
        vc.store = store
        self.rootViewController = vc
    }
}
