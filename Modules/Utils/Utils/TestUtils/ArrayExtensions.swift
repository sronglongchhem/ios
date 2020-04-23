import Foundation

#if DEBUG
public extension Array where Element: Equatable {
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
#endif
