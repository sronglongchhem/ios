import XCTest
import Architecture
import Models
import OtherServices
import RxBlocking
@testable import ___PROJECTNAME___

class ___VARIABLE_featureName___ReducerTests: XCTestCase {

    <#var now = Date(timeIntervalSince1970: 987654321)#>
    <#var mockTime: Time!#>
    var reducer: Reducer<___VARIABLE_featureName___State, ___VARIABLE_featureName___Action>!

    override func setUp() {
        <#mockTime = Time(getNow: { return self.now })#>
        reducer = create___VARIABLE_featureName___Reducer(<#param name#>: <#param value#>)
    }

    func test<#test name#>() {

        let state = ___VARIABLE_featureName___State(
            <#params#>
        )

        assertReducerFlow(
            initialState: state,
            reducer: reducer,
            steps:
            Step(.send, ___VARIABLE_featureName___Action.<#some action#>) {
                <#state changes go here#>
            },
            <#Step(.receive, ___VARIABLE_featureName___Action./*some action*/) { /*state changes go here*/ }#>
        )
    }
}
