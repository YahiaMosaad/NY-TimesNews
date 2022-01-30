//
//  NewsDetailsCoordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 28/01/2022.
//

import UIKit

final class NewsDetailsCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    let dependencies: NewsDetailsCoordinatorDependencies
    
    init(dependencies: NewsDetailsCoordinatorDependencies){
        self.dependencies = dependencies
    }
    func start() {
        let newsDetailsView: NewsDetailsView = .instance(input: viewModel)
        dependencies.navigationController.pushViewController(newsDetailsView, animated: false)
    }
    
    private lazy var viewModel: NewsDetailsViewModel = {
        return .instance(input: .init(newsFeed: dependencies.newDetails))
    }()
    
    func finish() {}

    struct NewsDetailsCoordinatorDependencies{
        let newDetails: NewsFeedData
        let navigationController: UINavigationController
    }
}
