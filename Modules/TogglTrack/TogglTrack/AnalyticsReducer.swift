import Foundation
import Architecture
import Analytics

func createAnalyticsReducer(analyticsService: AnalyticsService) -> (_ reducer: Reducer<AppState, AppAction>) -> Reducer<AppState, AppAction> {
    return { reducer in
        return Reducer { state, action in
            if let event = action.toEvent() {
                analyticsService.track(event: event)
            }
            return reducer.reduce(&state, action)
        }
    }
}
