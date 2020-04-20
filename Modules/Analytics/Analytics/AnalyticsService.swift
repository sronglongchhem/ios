import Foundation

public protocol AnalyticsService {
    func track(event: Event)
}
