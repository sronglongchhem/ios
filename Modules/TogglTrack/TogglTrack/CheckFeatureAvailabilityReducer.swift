import Foundation
import Architecture

public func checkFeatureAvailability(_ reducer: Reducer<AppState, AppAction>) -> Reducer<AppState, AppAction> {
    return Reducer { state, action in

        switch action {
        case .timer(.startEdit(.billableButtonTapped)):
            print("Billable button tapped, check if the user can do this")
        default:
            break
        }

        return reducer.reduce(&state, action)
    }
}
