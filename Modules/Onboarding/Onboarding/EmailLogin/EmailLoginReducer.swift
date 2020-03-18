import Foundation
import Architecture
import Models
import RxSwift
import API

func createEmailLoginReducer(api: UserAPI) -> Reducer<OnboardingState, EmailLoginAction> {
    return Reducer { state, action in
        
        switch action {
            
        case .goToSignup:
            state.route = OnboardingRoute.emailSignup
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
            
        case .loginTapped:
            state.user = .loading
            return [
                loadUser(email: state.email, password: state.password, api: api)
            ]
            
        case let .setUser(user):
            state.user = .loaded(user)
            api.setAuth(token: user.apiToken)
            state.route = AppRoute.main
            return []
            
        case let .setError(error):
            state.user = .error(error)
            return []
        }
    }
}

private func loadUser(email: String, password: String, api: UserAPI) -> Effect<EmailLoginAction> {
    return api.loginUser(email: email, password: password)
        .map({ EmailLoginAction.setUser($0) })
        .catchError({ Observable.just(EmailLoginAction.setError($0)) })
        .toEffect()
}
