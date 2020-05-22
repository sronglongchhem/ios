import Foundation
import Models
import Architecture
import Onboarding
import Timer
import Utils

public struct AppState {
    public var route: RoutePath = AppRoute.start.path
    public var user: Loadable<User> = .nothing
    public var entities: TimeLogEntities =  TimeLogEntities()
    
    private var _onboardingState: OnboardingState
    private var _timerState: TimerState

    init() {
        _onboardingState = OnboardingState(user: user, route: route)
        _timerState = TimerState(user: user, entities: entities)
    }
}

// Module specific states
extension AppState {
    
    var loadingState: LoadingState {
        get {
            LoadingState(
                entities: entities,
                route: route
            )
        }
        set {
            entities = newValue.entities
            route = newValue.route
        }
    }
    
    var onboardingState: OnboardingState {
        get {
            var copy = _onboardingState
            copy.route = route
            copy.user = user
            return copy
        }
        set {
            _onboardingState = newValue
            user = newValue.user
            route = newValue.route
        }
    }
    
    var timerState: TimerState {
        get {
            var copy = _timerState
            copy.entities = entities
            copy.user = user
            return copy
        }
        set {
            _timerState = newValue
            entities = newValue.entities
            user = newValue.user
        }
    }
}
