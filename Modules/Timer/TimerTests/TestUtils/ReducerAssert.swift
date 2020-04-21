import Foundation
import XCTest
import Architecture
import RxBlocking
import RxSwift
import RxTest

enum StepType {
    case send
    case receive
}

struct Step<State, Action> {
    let type: StepType
    let actions: [Action]
    let update: (inout State) -> Void
    let file: StaticString
    let line: UInt
    
    init(
        _ type: StepType,
        _ actions: [Action],
        file: StaticString = #file,
        line: UInt = #line,
        _ update: @escaping (inout State ) -> Void = { _ in }
    ) {
        self.type = type
        self.actions = actions
        self.update = update
        self.file = file
        self.line = line
    }

    init(
        _ type: StepType,
        _ action: Action,
        file: StaticString = #file,
        line: UInt = #line,
        _ update: @escaping (inout State ) -> Void = { _ in }
    ) {
        self.init(type, [action], file: file, line: line, update)
    }
}

func assertReducerFlow<State: Equatable, Action: Equatable>(
    initialState: State,
    reducer: Reducer<State, Action>,
    testScheduler: TestScheduler? = nil,
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
            let reducerEffects = step.actions.flatMap { reducer.reduce(&state, $0) }
            effects.append(contentsOf: reducerEffects)
            
        case .receive:
            guard !effects.isEmpty else {
                XCTFail("No pending effects to receive from", file: step.file, line: step.line)
                break
            }

            var actions = [Action]()
            if testScheduler == nil {
                actions = effects.compactMap { try? $0.asSingle().toBlocking().first() }
            } else {
                _ = Observable.from(effects.map({ $0.asSingle().asObservable() }))
                    .merge()
                    .toArray()
                    .subscribe(onSuccess: { actions = $0 })
                testScheduler!.start()
            }
            effects = []

            XCTAssert(actions.equalContents(to: step.actions), file: step.file, line: step.line)
            let reducerEffects = actions.flatMap { reducer.reduce(&state, $0) }
            effects.append(contentsOf: reducerEffects)
        }
        
        step.update(&expected)
        XCTAssertEqual(state, expected, file: step.file, line: step.line)
    }
    
    if !effects.isEmpty {
        XCTFail("Assertion failed to handle \(effects.count) pending effect(s)", file: file, line: line)
    }
}

extension Array where Element: Equatable {
    func equalContents(to other: [Element]) -> Bool {
        guard self.count == other.count else {return false}
        for element in self {
            guard self.filter({ $0 == element }).count == other.filter({ $0 == element }).count else {
                return false
            }
        }
        return true
    }
}
