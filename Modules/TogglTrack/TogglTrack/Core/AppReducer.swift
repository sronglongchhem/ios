import Foundation
import Architecture
import Timer

func createGlobalReducer() -> Reducer<AppState, AppAction> {
    return Reducer { state, action in
        switch action {
        case .start:
            if state.user.isLoaded {
                state.route = AppRoute.main
            } else {
                state.route = AppRoute.onboarding
            }
            return .empty
            
        case let .tabBarTapped(section):
            state.route = [
                TabBarRoute.timer,
                TabBarRoute.reports,
                TabBarRoute.calendar
                ][section]
            return .empty
            
        case .onboarding, .timer, .startEdit:
            return .empty
        }
    }
}
