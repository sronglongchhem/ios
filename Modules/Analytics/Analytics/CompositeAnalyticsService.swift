import Foundation

public class CompositeAnalyticsService: AnalyticsService {
    private let analyticsServices: [AnalyticsService]
    
    public init(analyticsServices: [AnalyticsService]) {
        self.analyticsServices = analyticsServices
    }
    
    public func track(event: Event) {
        analyticsServices.forEach { $0.track(event: event) }
    }
}
