//
//  AppCoordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import UIKit

final class AppCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    
    private let window: UIWindow!
    private lazy var navigationController: UINavigationController = {
        UINavigationController()
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {//make desision about the landing scene
        let launchStateManager: LaunchStateManager = .init()
        let status = launchStateManager.getLaunchState()
        
        switch status {
        case .guest:
            let coordinator: LoginViewCoordinator = .init(navigationController: navigationController)
            coordinator.start()
        case .onboarding:
            let coordinator: LoginViewCoordinator = .init(navigationController: navigationController)
            coordinator.start()
        case .loggedIn:
            let coordinator: NewsListCoordinator = .init(navigationController: navigationController)
            coordinator.start()
        }
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func finish() {
    }
}

