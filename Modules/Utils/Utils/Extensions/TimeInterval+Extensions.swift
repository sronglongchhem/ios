import Foundation

extension TimeInterval {
    
    static var formatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        return formatter
    }

    public func formattedDuration() -> String {
        return TimeInterval.formatter.string(from: self)!
    }
}
