//
//  NewsListViewModel.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation
import UIKit

final class NewsListViewModel: ObservableObject {
    var newsList: [NewsFeedData]?
    var showLoadingIndicator: Bool = false
    var errorMessag: String?

//    let dependencies: NewsListDependincies
    
    private let actions: NewsListActions//to coordinator
    private let getNewsListUseCase: GetNewsUseCase

//    init(dependencies: NewsListDependincies){
//        self.dependencies = dependencies
//        print("init NewsListViewModel")
//    }
    init(actions: NewsListActions, getNewsListUseCase: GetNewsUseCase) {
        self.actions = actions
        self.getNewsListUseCase = getNewsListUseCase
    }
    
    func viewDidLoad(){
        newsList = loadNews(with: .week)
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
    
    private func loadNews(with period: NewsPeriod) -> [NewsFeedData] {
        showLoadingIndicator.toggle()
//        dependencies
        return self.getNewsListUseCase.execute(period)
    }
    private func handleGetItemsError(error: GetNewsUseCaseError){
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
            return
        }
//        dependencies.actions.showNewsDetails(details)
        self.actions.showNewsDetails(details)
    }
}

//extension NewsListViewModel: Dependant{
//    typealias Dependenceis = NewsListDependincies
//    static func instance(input: Dependenceis) -> NewsListViewModel {
//        return NewsListViewModel(dependencies: input)
//    }
//    struct NewsListDependincies{
//        let actions: NewsListActions//to coordinator
//        let getNewsListUseCase: GetNewsUseCase
//    }
//}

struct NewsListActions{//communication from view model to coordinator
    let showNewsDetails: (NewsFeedData) -> ()

}


