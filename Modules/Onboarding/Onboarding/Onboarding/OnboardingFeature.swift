import UIKit
import Architecture
import API

public func createOnboardingReducer(userAPI: UserAPI) -> Reducer<OnboardingState, OnboardingAction> {
    return combine(
        createMainOnboardingReducer(),
        createEmailLoginReducer(api: userAPI).pullback(action: \.emailLogin),
        createEmailSignupReducer(api: userAPI).pullback(action: \.emailSignup)
    )
}

public class OnboardingFeature: BaseFeature<OnboardingState, OnboardingAction> {
    let features = [
        OnboardingRoute.emailLogin.rawValue: EmailLoginFeature()
        .view { $0.view(
                state: { $0 },
                action: { OnboardingAction.emailLogin($0) })
        },
        OnboardingRoute.emailSignup.rawValue: EmailSignupFeature()
        .view { $0.view(
                state: { $0 },
                action: { OnboardingAction.emailSignup($0) })
        }
    ]
    
    public override func mainCoordinator(store: Store<OnboardingState, OnboardingAction>) -> Coordinator {
        return OnboardingCoordinator(store: store, features: features)
    }
}
