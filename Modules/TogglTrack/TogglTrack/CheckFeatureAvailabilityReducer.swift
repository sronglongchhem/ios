import Foundation
import Architecture

public func checkFeatureAvailability<State, Action>(
    _ reducer: Reducer<State, Action>
) -> Reducer<State, Action> {
    return Reducer { state, action in
        switch action {
        
        //case for each action that needs feature availability checked
            
        default:
            return reducer.reduce(&state, action)
        }
    }
}
