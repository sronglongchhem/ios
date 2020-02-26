//
//  AppReducer.swift
//  Toggl-iOS
//
//  Created by Ricardo Sánchez Sotres on 13/02/2020.
//  Copyright © 2020 Ricardo Sánchez Sotres. All rights reserved.
//

import Foundation
import Architecture
import Timer

var globalReducer: Reducer<AppState, AppAction, AppEnvironment> = Reducer { state, action, environment in
    switch action
    {
        case .setBackgroundStatus:
            state.appStatus = .background
            
        case .setForegroundStatus:
            state.appStatus = .foreground
            
//        case .onboarding(.setUser(_)):            
//            return Effect.from(action: .timer(.load))
        
        case .onboarding, .timer:
            break                    
    }
    
    return .empty
}