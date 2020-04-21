import Foundation
import API
import Repository
import Networking
import OtherServices
import Timer
import Database
import Analytics

public struct AppEnvironment {
    public let api: API
    public let repository: Repository
    public let time: Time
    public let schedulerProvider: SchedulerProvider
    public let analytics: AnalyticsService

    public init(api: API, repository: Repository, time: Time, schedulerProvider: SchedulerProvider, analytics: AnalyticsService) {
        self.api = api
        self.repository = repository
        self.time = time
        self.schedulerProvider = schedulerProvider
        self.analytics = analytics
    }

    public init() {
        self.api = API(urlSession: FakeURLSession())
//        self.api = API(urlSession: URLSession(configuration: URLSessionConfiguration.default))
        self.time = Time()
        self.repository = Repository(api: api, database: Database(), time: time)
        self.schedulerProvider = SchedulerProvider()
        let firebaseAnalytics = FirebaseAnalyticsService()
        let appCenterAnalytics = AppCenterAnalyticsService()
        self.analytics = CompositeAnalyticsService(analyticsServices: [firebaseAnalytics, appCenterAnalytics])
    }
}

extension AppEnvironment {
    var userAPI: UserAPI {
        return api
    }
}
