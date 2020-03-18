import Foundation
import Architecture
import Onboarding
import Timer

func createAppReducer(environment: AppEnvironment) -> Reducer<AppState, AppAction> {
    return combine(
        createGlobalReducer(),
        createOnboardingReducer(userAPI: environment.userAPI).pullback(state: \.onboardingState, action: \.onboarding),
        createTimerReducer(repository: environment.repository, time: environment.time).pullback(state: \.timerState, action: \.timer)
    )
}

public class AppFeature: BaseFeature<AppState, AppAction> {

    let features: [String: BaseFeature<AppState, AppAction>] = [
        AppRoute.onboarding.rawValue: OnboardingFeature()
            .view { $0.view(
                    state: { $0.onboardingState },
                    action: { AppAction.onboarding($0) })
            },
        AppRoute.main.rawValue: TimerFeature()
        .view { $0.view(
                state: { $0.timerState },
                action: { AppAction.timer($0) })
        }
    ]

    public override func mainCoordinator(store: Store<AppState, AppAction>) -> Coordinator {
        return AppCoordinator(
            store: store,
            onboardingCoordinator: features[AppRoute.onboarding.rawValue]!.mainCoordinator(store: store),
            tabBarCoordinator: MainCoordinator(
                store: store,
                timerCoordinator: (features[AppRoute.main.rawValue]!.mainCoordinator(store: store) as? TimerCoordinator)!
            )
        )
    }
}
