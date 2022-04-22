//
//  NewsListViewModel.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation
import Combine
import UIKit

final class NewsListViewModel: ObservableObject {
    var newsList: [NewsFeedData]?
    var showLoadingIndicator: Bool = false
    var errorMessag: String?

    let dependencies: NewsListDependincies
    private var cancellables: Set<AnyCancellable> = []

    init(dependencies: NewsListDependincies){
        self.dependencies = dependencies
        print("init NewsListViewModel")
    }
    
    func viewDidLoad(){
        self.loadNews(with: .week)
    }
    func didChangeSegementValue (segement: NewsListViewSegment){
        switch segement
        {
        case NewsListViewSegment.day:
            self.loadNews(with: NewsPeriod.day)
        case NewsListViewSegment.week:
            self.loadNews(with: NewsPeriod.week)
        case NewsListViewSegment.month:
            self.loadNews(with: NewsPeriod.month)
            
        }
    }
    
    private func loadNews(with period: NewsPeriod) {
        showLoadingIndicator.toggle()
        newsList = dependencies.getNewsListUseCase.execute(period)
    }
    private func handleGetItemsError(error: GetNewsUseCase.GetNewsUseCaseError){
        switch error{
        case .noInternetConnection:
            print("noInternetConnection")
            errorMessag = ErrorMessages.noInternetMessage
        case .invalidAPIKey , .noDataFound:
            print("invalidAPIKey")
            errorMessag = ErrorMessages.noDataMessage
        

        }
    }
    func didSelectNews(at index: Int) {
        guard let details =  newsList?[index] else{
            dependencies.actions.dismiss()
            return
        }
        dependencies.actions.showNewsDetails(details)
    }
    
    deinit{
        print("deinit Items list view model")
        _ = cancellables.map{$0.cancel()}
    }
}

extension NewsListViewModel: BaseDependant {
    typealias Dependenceis = NewsListDependincies
    static func instance(input: Dependenceis) -> NewsListViewModel {
        return NewsListViewModel(dependencies: input)
    }
    struct NewsListDependincies{
        let actions: NewsListActions//to coordinator
        let getNewsListUseCase: GetNewsUseCase
    }
}

struct NewsListActions{//communication from view model to coordinator
    let showNewsDetails: (NewsFeedData) -> ()
    let dismiss: () -> ()
}


