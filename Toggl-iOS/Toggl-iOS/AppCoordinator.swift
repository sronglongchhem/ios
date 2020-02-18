//
//  AppCoordinator.swift
//  Toggl-iOS
//
//  Created by Ricardo Sánchez Sotres on 17/02/2020.
//  Copyright © 2020 Ricardo Sánchez Sotres. All rights reserved.
//

import UIKit
import UIExtensions
import Architecture
import Onboarding
import TimeEntriesLog

class AppCoordinator : Coordinator
{
    private let store: Store<AppState, AppAction, AppEnvironment>
    private let navigationController = UINavigationController()
    private let window: UIWindow
        
    init(window: UIWindow, store: Store<AppState, AppAction, AppEnvironment>)
    {
        self.window = window
        self.store = store
    }
    
    func start()
    {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
//        if userLoggedIn {
//
//        } else {
            showOnboarding()
//        }
    }
    
    private func showOnboarding()
    {
        let onboardingCoordinator = OnboardingCoordinator(
            navigationController: navigationController,
            store: store.view(
                state: { $0.user },
                action: { .onboarding($0) },
                environment: { $0.api }
            )
        )
        onboardingCoordinator.loggedIn = {
            self.showTimeEntryLog()
        }
        onboardingCoordinator.start()
    }
    
    private func showTimeEntryLog()
    {
        let timeEntriesLog = TimeEntriesLogCoordinator(navigationController: navigationController)
        timeEntriesLog.start()
    }
}