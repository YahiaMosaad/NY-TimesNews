//
//  NewsLisrCoordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import UIKit

final class NewsListCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    let dependencies: NewsListCoordinatorDependencies
    
    init(dependencies: NewsListCoordinatorDependencies){
        self.dependencies = dependencies
    }
    
    func start() {
        let newsListView: NewsListView = .instance(input: viewModel)
        dependencies.navigationController.pushViewController(newsListView, animated: false)
    }
    
    private lazy var viewModel: NewsListViewModel = {
        return .instance(input: .init(
            actions: NewsListActions(showNewsDetails: showNewsDetails),
            getNewsListUseCase:
                    .instance(input: .init(newsListRepository: NewsListRepositoryImp(network: HTTPClient.defaultClient)))
            //                .mockedUseCase

            ))
                    
    }()
    
    func finish() {
        removeAllChildCoordinators()
    }
    func showNewsDetails(newsDetails: NewsFeedData){
        let coordinator: NewsDetailsCoordinator = .init(dependencies: .init(newDetails: newsDetails, navigationController: dependencies.navigationController))
        addChildCoordinator(coordinator)
        coordinator.start()
    }

    struct NewsListCoordinatorDependencies{
        let navigationController: UINavigationController
    }
}

extension NewsListCoordinator: Dependant{
    typealias Dependenceis = NewsListCoordinatorDependencies
    
    static func instance(input: Dependenceis) -> NewsListCoordinator {
        return NewsListCoordinator(dependencies: input)
    }
}

