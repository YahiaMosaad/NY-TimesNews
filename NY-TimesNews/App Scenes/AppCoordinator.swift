//
//  AppCoordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    let dependencies: UIWindow
    
    private lazy var navigationController: UINavigationController = {
        UINavigationController()
    }()
    
    init(dependencies: UIWindow) {
        self.dependencies = dependencies
    }
    
    
    func start() {//make desision about the landing scene
        let newsListCoordinatorDependencies = NewsListCoordinator.NewsListCoordinatorDependencies(navigationController: navigationController)
        let coordinator = NewsListCoordinator(dependencies: newsListCoordinatorDependencies)
        coordinator.start()
        
        dependencies.rootViewController = navigationController
        dependencies.makeKeyAndVisible()
    }
    
    func finish() {}
}

