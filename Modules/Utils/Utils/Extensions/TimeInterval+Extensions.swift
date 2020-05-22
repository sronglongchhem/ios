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

    public static func from(hours: Int) -> TimeInterval {
        TimeInterval(hours * 60 * 60)
    }

    public static func from(minutes: Int) -> TimeInterval {
        TimeInterval(minutes * 60)
    }

    public static var maximumTimeEntryDuration = TimeInterval.from(hours: 999)

    public func clamp(_ range: ClosedRange<TimeInterval>) -> TimeInterval {
        return range.lowerBound > self ? range.lowerBound
            : range.upperBound < self ? range.upperBound
            : self
    }
}

public extension TimeInterval {
    static var maxTimeEntryDuration: TimeInterval { 999 * TimeInterval(Int.secondsInAnHour) }
}
