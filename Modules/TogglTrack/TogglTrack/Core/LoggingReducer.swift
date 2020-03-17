import Foundation
import Architecture

public func logging<State, Action>(
    _ reducer: Reducer<State, Action>
) -> Reducer<State, Action> {
    return Reducer { state, action in
        print("Action: \(action)")
        return reducer.reduce(&state, action)
    }
}
