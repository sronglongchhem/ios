import Foundation
import Architecture

class RunningTimeEntryFeature: BaseFeature<RunningTimeEntryState, RunningTimeEntryAction> {
    override func mainCoordinator(store: Store<RunningTimeEntryState, RunningTimeEntryAction>) -> Coordinator {
        return RunningTimeEntryCoordinator(store: store)
    }
}
