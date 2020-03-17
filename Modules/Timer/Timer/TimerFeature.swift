import Foundation
import Architecture
import Repository

public func createTimerReducer(repository: Repository) -> Reducer<TimerState, TimerAction> {
    return combine(
        createTimeEntriesLogReducer(repository: repository).pullback(state: \.timeLogState, action: \.timeLog),
        createStartEditReducer(repository: repository).pullback(state: \.startEditState, action: \.startEdit)
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
