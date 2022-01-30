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
        let coordinator: NewsListCoordinator =
            .init(dependencies: .init(navigationController: navigationController))
        coordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private lazy var newsListCoordinator: NewsListCoordinator = {
        .init(dependencies: .init(navigationController: navigationController))
    }()
    
    func finish() {
    }
}

