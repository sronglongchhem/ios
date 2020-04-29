import Foundation
import Architecture
import OtherServices

class StartEditFeature: BaseFeature<StartEditState, StartEditAction> {

    private let time: Time

    init(time: Time) {
        self.time = time
    }

    override func mainCoordinator(store: Store<StartEditState, StartEditAction>) -> Coordinator {
        return StartEditCoordinator(store: store, time: time)
    }
}
