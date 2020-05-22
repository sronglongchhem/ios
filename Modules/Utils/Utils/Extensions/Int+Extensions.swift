import Foundation

public extension Int {
    init(ceiling value: Double) {
        self.init(ceil(value))
    }
    
    func clamp(_ range: ClosedRange<Int>) -> Int {
        return range.lowerBound > self ? range.lowerBound
            : range.upperBound < self ? range.upperBound
            : self
    }
}
