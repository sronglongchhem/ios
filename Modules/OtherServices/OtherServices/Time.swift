import Foundation

public class Time {
    
    public let now: () -> Date
    
    public init(getNow: @escaping () -> Date = Date.init) {
         self.now = getNow
    }
}
