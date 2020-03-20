import Foundation
import Models
import Architecture
import Onboarding
import Timer
import Utils

public struct AppState {
    public var route: Route = AppRoute.start
    public var user: Loadable<User> = .nothing
    public var entities: TimeLogEntities =  TimeLogEntities()
    
    public var localLoadingState: LocalLoadingState = LocalLoadingState()
    public var localOnboardingState: LocalOnboardingState = LocalOnboardingState()
    public var localTimerState: LocalTimerState = LocalTimerState()
}

// Module specific states
extension AppState {
    
    var loadingState: LoadingState {
        get {
            LoadingState(
                entities: entities,
                route: route,
                localLoadingState: localLoadingState
            )
        }
        set {
            entities = newValue.entities
            route = newValue.route
            localLoadingState = newValue.localLoadingState
        }
    }
    
    var onboardingState: OnboardingState {
        get {
            OnboardingState(
                user: user,
                route: route,
                localOnboardingState: localOnboardingState
            )
        }
        set {
            user = newValue.user
            route = newValue.route
            localOnboardingState = newValue.localOnboardingState
        }
    }
    
    var timerState: TimerState {
        get {
            TimerState(
                user: user,
                entities: entities,
                localTimerState: localTimerState
            )
        }
        
        set {
            user = newValue.user
            entities = newValue.entities
            localTimerState = newValue.localTimerState
        }
    }
}
