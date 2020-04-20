import Foundation
import Architecture

public func checkFeatureAvailability(_ reducer: Reducer<AppState, AppAction>) -> Reducer<AppState, AppAction> {
    return Reducer { state, action in
        if isBillableTappedAction(action) {
            print("Billable button tapped, check if the user can do this")
        }
        
        return reducer.reduce(&state, action)
    }
}

func isBillableTappedAction(_ action: AppAction) -> Bool {
    guard case let .timer(timerAction) = action else { return false }
    guard case let .startEdit(startEditAction) = timerAction else { return false }
    return startEditAction == .billableButtonTapped
}
