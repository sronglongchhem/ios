import Foundation
import Architecture

public func checkFeatureAvailability<State, Action, Environment>(
    _ reducer: Reducer<State, Action, Environment>
) -> Reducer<State, Action, Environment> {
    return Reducer { state, action, environment in
        switch action {
        
        //case for each action that needs feature availability checked
            
        default:
            return reducer.reduce(&state, action, environment)
        }
    }
}
