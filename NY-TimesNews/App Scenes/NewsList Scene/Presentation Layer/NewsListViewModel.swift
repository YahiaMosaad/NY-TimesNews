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
    @Published var newsList: [NewsFeedData]?
    @Published var showLoadingIndicator: Bool = false
    @Published var errorMessag: String?

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
        dependencies
              .getNewsListUseCase
              .execute(period)
              .receive(on: RunLoop.main)
              .sink { [weak self] (completion) in
                  if case let .failure(error) = completion {
                      self?.handleGetItemsError(error: error)
                  }
                  self?.showLoadingIndicator = false
              } receiveValue: { [weak self] receivedNews in
                  self?.newsList = receivedNews?.results
              }.store(in: &cancellables)
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
            return
        }
        dependencies.actions.showNewsDetails(details)
    }
    
    deinit{
        print("deinit Items list view model")
        _ = cancellables.map{$0.cancel()}
    }
}

extension NewsListViewModel: Dependant{
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

}


