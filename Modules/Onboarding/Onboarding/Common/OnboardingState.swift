import Foundation
import Models
import Architecture
import Utils

public struct LocalOnboardingState: Equatable {
    internal var email: String = ""
    internal var password: String = ""
    
    public init() {
    }
}

public struct OnboardingState: Equatable {
    public var user: Loadable<User>
    public var route: RoutePath
    public var localOnboardingState: LocalOnboardingState
    
    public init(user: Loadable<User>, route: RoutePath, localOnboardingState: LocalOnboardingState) {
        self.user = user
        self.route = route
        self.localOnboardingState = localOnboardingState
    }
}

extension OnboardingState {
    internal var email: String {
        get {
            localOnboardingState.email
        }
        set {
            localOnboardingState.email = newValue
        }
    }
    
    internal var password: String {
        get {
            localOnboardingState.password
        }
        set {
            localOnboardingState.password = newValue
        }
    }
}
