import Foundation

extension String {
    public func nsRange(from range: Range<String.Index>) -> NSRange {
        let startPos = self.distance(from: self.startIndex, to: range.lowerBound)
        let endPos = self.distance(from: self.startIndex, to: range.upperBound)
        return NSRange(location: startPos, length: endPos - startPos)
    }
}
