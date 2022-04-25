//
//  AppCoordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import UIKit

final class AppCoordinator: Coordinator{
    internal let dependencies: UIWindow
    private lazy var navigationController: UINavigationController = {
        UINavigationController()
    }()
    
    init(dependencies: UIWindow) {
        self.dependencies = dependencies
    }
    
    func start() {//make desision about the landing scene
        let launchStateManager: LaunchStateManager = .init()
        let status = launchStateManager.getLaunchState()
        
        switch status {
        case .guest:
            let coordinator: LoginViewCoordinator = .init(dependencies: navigationController)
            coordinator.start()
        case .onboarding:
            let coordinator: LoginViewCoordinator = .init(dependencies: navigationController)
            coordinator.start()
        case .loggedIn:
            let coordinator: NewsListCoordinator = .init(navigationController: navigationController)
            coordinator.start()
        }
        
        dependencies.rootViewController = navigationController
        dependencies.makeKeyAndVisible()
    }
    
    func finish() {
    }
}

