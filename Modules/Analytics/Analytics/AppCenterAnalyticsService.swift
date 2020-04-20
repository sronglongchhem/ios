import Foundation
import AppCenter
import AppCenterAnalytics

public class AppCenterAnalyticsService: AnalyticsService {
    public init() {
        
    }
    
    public func track(event: Event) {
        MSAnalytics.trackEvent(event.name, withProperties: event.parameters as? [String: String])
    }
}
