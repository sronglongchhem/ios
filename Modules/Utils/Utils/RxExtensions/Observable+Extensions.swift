import Foundation
import RxSwift

extension ObservableConvertibleType {
    public func mapTo<Result>(_ value: Result) -> Observable<Result> {
        return asObservable().map { _ in value }
    }
    public func mapTo<Result>(_ transform: @escaping (Element) -> Result) -> Observable<Result> {
        return asObservable().map(transform)
    }
}
