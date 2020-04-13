import Foundation
import Architecture

class ___VARIABLE_featureName___Feature: BaseFeature<___VARIABLE_featureName___State, ___VARIABLE_featureName___Action> {
    override func mainCoordinator(store: Store<___VARIABLE_featureName___State, ___VARIABLE_featureName___Action>) -> Coordinator {
        return ___VARIABLE_featureName___Coordinator(store: store)
    }
}
