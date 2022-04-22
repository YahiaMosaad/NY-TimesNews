//
//  NewsLisrCoordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import UIKit

final class NewsListCoordinator: BaseCoordinator {
    let dependencies: NewsListCoordinatorDependencies
    
    init(dependencies: NewsListCoordinatorDependencies){
        self.dependencies = dependencies
    }
    
    func start() {
        let newsListView = NewsListViewController.instance(input: viewModel)
        dependencies.navigationController.pushViewController(newsListView, animated: false)
    }
    
    private lazy var viewModel: NewsListViewModel = {
        let action = NewsListActions(showNewsDetails: showNewsDetails, dismiss: dismiss)
        let repo = NewsListRepository(network: HTTPClient.defaultClient)
        let useCase = GetNewsUseCase(dependencies: GetNewsUseCase.GetNewsUseCaseDependencies(newsListRepository: repo))
        let dependencies = NewsListViewModel.NewsListDependincies(actions: action, getNewsListUseCase: useCase)
        return NewsListViewModel(dependencies: dependencies)
    }()
    
    func finish() {}
    
    func showNewsDetails(newsDetails: NewsFeedData){
        let dependencies = NewsDetailsCoordinator.NewsDetailsCoordinatorDependencies(newDetails: newsDetails,
                                                                                     navigationController: dependencies.navigationController)
        let coordinator = NewsDetailsCoordinator(dependencies: dependencies)
        coordinator.start()
    }
    
    func dismiss() {
        dependencies.navigationController.dismiss(animated: true)
    }

    struct NewsListCoordinatorDependencies{
        let navigationController: UINavigationController
    }
}

