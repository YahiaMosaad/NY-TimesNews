//
//  LaunchStateManager.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 22/04/2022.
//

import Foundation

enum LaunchState{
    case guest, onboarding, loggedIn
}

final class LaunchStateManager{
    func updateState(_ state: LaunchState){
        UserDefaults.standard.set(state, forKey: "LaunchState")
    }
    
    func getLaunchState()-> LaunchState{
        return .loggedIn
//        UserDefaults.standard.value(forKey: "LaunchState") as? LaunchState ?? .guest
    }
}
