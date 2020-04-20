import Foundation
import Firebase
import FirebaseAnalytics

public class FirebaseAnalyticsService: AnalyticsService {
    public init() {
        
    }
    
    public func track(event: Event) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}
