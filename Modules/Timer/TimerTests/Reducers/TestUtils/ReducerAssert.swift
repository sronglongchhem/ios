import Foundation
import XCTest
import Architecture
import RxBlocking

enum StepType {
    case send
    case receive
}

struct Step<State, Action> {
    let type: StepType
    let action: Action
    let update: (inout State) -> Void
    let file: StaticString
    let line: UInt
    
    init(
        _ type: StepType,
        _ action: Action,
        file: StaticString = #file,
        line: UInt = #line,
        _ update: @escaping (inout State ) -> Void = { _ in }
    ) {
        self.type = type
        self.action = action
        self.update = update
        self.file = file
        self.line = line
    }
}

func assertReducerFlow<State: Equatable, Action: Equatable>(
    initialState: State,
    reducer: Reducer<State, Action>,
    steps: Step<State, Action>...,
    file: StaticString = #file,
    line: UInt = #line
) {
    var state = initialState
    var effects = [Effect<Action>]()
    steps.forEach { step in
        var expected = state
        
        switch step.type {
        
        case .send:
            if !effects.isEmpty {
                XCTFail("Action sent before handling \(effects.count) pending effect(s)", file: step.file, line: step.line)
            }
            let reducerEffects = reducer.reduce(&state, step.action)
            effects.append(contentsOf: reducerEffects)
            
        case .receive:
            guard !effects.isEmpty else {
                XCTFail("No pending effects to receive from", file: step.file, line: step.line)
                break
            }
            let effect = effects.removeFirst()
            guard let action = try? effect.asSingle().toBlocking().first() else {
                XCTFail("No action emitted from effect", file: step.file, line: step.line)
                break
            }
            XCTAssertEqual(action, step.action, file: step.file, line: step.line)
            let reducerEffects = reducer.reduce(&state, action)
            effects.append(contentsOf: reducerEffects)
        }
        
        step.update(&expected)
        XCTAssertEqual(state, expected, file: step.file, line: step.line)
    }
    
    if !effects.isEmpty {
        XCTFail("Assertion failed to handle \(effects.count) pending effect(s)", file: file, line: line)
    }
}
