import Foundation
import RxSwift

public struct Effect<Action> {
    
    let single: Single<Action>
    
    fileprivate init(single: Single<Action>) {
        self.single = single
    }
        
    public func map<B>(_ transform: @escaping (Action) throws -> B) -> Effect<B> {
        return Effect<B>(single: single.map(transform))
    }
    
    public static var empty: Effect<Action> { Observable.empty().toEffect() }
    
    public static func from(action: Action) -> Effect {
        return Effect(single: Single.just(action))
    }    
}

public extension ObservableConvertibleType {
    
    func toEffect() -> Effect<Element> {
        return Effect(single: self.asObservable().asSingle())
    }
    
    func toEffect<Action>(
        map mapOutput: @escaping (Element) -> Action,
        catch catchErrors: @escaping (Error) -> Action
    ) -> Effect<Action> {
        return self.asObservable()
            .map(mapOutput)
            .catchError { Observable<Action>.just(catchErrors($0)) }
            .toEffect()
    }
}
