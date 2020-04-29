import Foundation
import RxSwift
import RxCocoa

extension Driver {
    public func compactMap<B>(_ transform: @escaping (Element) -> B?) -> Driver<B> {
        return map(transform).filter({ $0 != nil }).asDriver(onErrorJustReturn: nil).map({ $0! })
    }
}
