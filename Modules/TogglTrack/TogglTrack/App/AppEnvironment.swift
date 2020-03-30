import Foundation
import API
import Repository
import Networking
import OtherServices
import Timer
import Database

public struct AppEnvironment {
    public let api: API
    public let repository: Repository
    public let time: Time

    public init(api: API, repository: Repository, time: Time) {
        self.api = api
        self.repository = repository
        self.time = time
    }

    public init() {
        self.api = API(urlSession: FakeURLSession())
//        self.api = API(urlSession: URLSession(configuration: URLSessionConfiguration.default))
        self.repository = Repository(api: api, database: Database())
        self.time = Time()
    }
}

extension AppEnvironment {
    var userAPI: UserAPI {
        return api
    }
}
