import Foundation
import Architecture
import RxSwift
import API

func createMainOnboardingReducer() -> Reducer<OnboardingState, OnboardingAction> {
    return Reducer { state, action in
        
        switch action {
            
        case .emailSingInTapped:
            state.route = OnboardingRoute.emailLogin.path
            return []
            
        case .emailLogin, .emailSignup:
            return []
        }
    }
}
