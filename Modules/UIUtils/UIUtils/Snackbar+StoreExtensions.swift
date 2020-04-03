import Architecture
import Utils

public extension Snackbar {

    // Factory method to use specifically with a Store

    static func with<State, Action>(text: String, buttonTitle: String? = nil, store: Store<State, Action>, action: Action) -> Snackbar {
        return Snackbar.with(text: text, buttonTitle: buttonTitle) {
            store.dispatch(action)
        }
    }
}
