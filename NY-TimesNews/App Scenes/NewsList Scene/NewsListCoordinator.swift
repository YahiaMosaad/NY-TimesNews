//
//  NewsLisrCoordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import UIKit

final class NewsListCoordinator: Coordinator{
//    let dependencies: NewsListCoordinatorDependencies // use this way if there are many dependancies
    
    internal let dependencies: UINavigationController
//    init(dependencies: NewsListCoordinatorDependencies){
//        self.dependencies = dependencies
//    }
    
    
    init(navigationController: UINavigationController){
        self.dependencies = navigationController
    }
    //Use this way when using struct of dependencies
//    func start() {
//        let newsListView: NewsListView = .instance(input: viewModel)
//        dependencies.navigationController.pushViewController(newsListView, animated: false)
//    }
    func start() {
        let newsListView: NewsListView = .instantiate()
        newsListView.viewModel = .init(actions: .init(showNewsDetails: showNewsDetails(newsDetails:)), getNewsListUseCase: GetNewsUseCaseImp(newsListRepository: NewsListRepositoryImp(network: .defaultClient)))
        dependencies.pushViewController(newsListView, animated: false)

    }
    
    func finish() {}
    
//    func start() {
//        let newsListView: NewsListView = .instantiate()
//        newsListView.viewModel = .init(dependencies: .init(actions: .init(showNewsDetails: showNewsDetails(newsDetails:)), getNewsListUseCase: GetNewsUseCaseImp(newsListRepository: NewsListRepositoryImp(network: .defaultClient))))
//        navigationController.pushViewController(newsListView, animated: false)
//    }
    
//    private lazy var viewModel: NewsListViewModel = {
//        return .instance(input: .init(
//            actions: NewsListActions(showNewsDetails: showNewsDetails),
//            getNewsListUseCase:
//                    .instance(input: .init(newsListRepository: NewsListRepositoryImp(network: HTTPClient.defaultClient)))
//            //                .mockedUseCase
//
//            ))
//
//    }()
    
    func showNewsDetails(newsDetails: NewsFeedData){
        let coordinator: NewsDetailsCoordinator = .init(dependencies: .init(newDetails: newsDetails, navigationController: dependencies))
        coordinator.start()
//        let coordinator: NewsDetailsCoordinator = .init(dependencies: .init(newDetails: newsDetails, navigationController: dependencies.navigationController))
//        coordinator.start()
    }

//    struct NewsListCoordinatorDependencies{
//        let navigationController: UINavigationController
//    }
}

//extension NewsListCoordinator: Dependant{
//    typealias Dependenceis = NewsListCoordinatorDependencies
//
//    static func instance(input: Dependenceis) -> NewsListCoordinator {
//        return NewsListCoordinator(dependencies: input)
//    }
//}

