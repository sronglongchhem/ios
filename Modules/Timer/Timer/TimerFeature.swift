import Foundation
import Architecture
import Repository
import OtherServices

public func createTimerReducer(repository: Repository, time: Time) -> Reducer<TimerState, TimerAction> {
    return combine(
        createTimeEntriesLogReducer(repository: repository, time: time).pullback(state: \.timeLogState, action: \.timeLog),
        createStartEditReducer(repository: repository, time: time).pullback(state: \.startEditState, action: \.startEdit)
    )
}

public class TimerFeature: BaseFeature<TimerState, TimerAction> {

    let features: [String: BaseFeature<TimerState, TimerAction>] = [
        "log": TimeEntriesLogFeature()
            .view { $0.view(
                state: { $0.timeLogState },
                action: { TimerAction.timeLog($0) })
        },
        "startEdit": StartEditFeature()
            .view { $0.view(
                state: { $0.startEditState },
                action: { TimerAction.startEdit($0) })
        }
    ]

    public override func mainCoordinator(store: Store<TimerState, TimerAction>) -> Coordinator {
        return TimerCoordinator(
            store: store,
            timeLogCoordinator: (features["log"]!.mainCoordinator(store: store) as? TimeEntriesLogCoordinator)!,
            startEditCoordinator: (features["startEdit"]!.mainCoordinator(store: store) as? StartEditCoordinator)!
        )
    }
}
