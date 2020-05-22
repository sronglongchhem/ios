import Foundation
import Models
import Architecture
import Utils

public struct OnboardingState: Equatable {
    public var user: Loadable<User>
    public var route: RoutePath

    internal var email: String = ""
    internal var password: String = ""

    public init(user: Loadable<User>, route: RoutePath) {
        self.user = user
        self.route = route
    }
}
