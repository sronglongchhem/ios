import Foundation

extension Collection {
    public func none(_ predicate: (Element) -> Bool) -> Bool {
        return filter(predicate).isEmpty
    }
}
