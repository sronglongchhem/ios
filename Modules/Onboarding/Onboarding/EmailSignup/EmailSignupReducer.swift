import Foundation
import Architecture
import Models
import RxSwift
import API

func createEmailSignupReducer(api: UserAPI) -> Reducer<OnboardingState, EmailSignupAction> {
    
    return Reducer { state, action in
        switch action {
            
        case .goToLogin:
            state.route = OnboardingRoute.emailLogin
            return []
            
        case .cancel:
            state.route = AppRoute.onboarding
            return []
            
        case let .emailEntered(email):
            state.email = email
            return []
            
        case let .passwordEntered(password):
            state.password = password
            return []
            
        case .signupTapped:
            state.user = .loading
            return []
            
        case let .setError(error):
            state.user = .error(error)
            return []
        }                
    }
}
