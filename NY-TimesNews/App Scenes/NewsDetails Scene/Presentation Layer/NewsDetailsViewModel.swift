//
//  NewsDetailsViewModel.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 28/01/2022.
//

import Foundation
import Combine

final class NewsDetailsViewModel: ObservableObject {
    @Published var newsDetails: NewsFeedData?
    let dependencies: NewsDetailsDependincies
    private var cancellables: Set<AnyCancellable> = []

    init(dependencies: NewsDetailsDependincies){
        self.dependencies = dependencies
        print("init NewsDetailsViewModel")
    }
    func viewDidLoad(){
        newsDetails = dependencies.newsFeed
    }
}
extension NewsDetailsViewModel: BaseDependant {
    typealias Dependenceis = NewsDetailsDependincies
    static func instance(input: Dependenceis) -> NewsDetailsViewModel {
        return NewsDetailsViewModel(dependencies: input)
    }
    struct NewsDetailsDependincies{
        let newsFeed: NewsFeedData
    }
}
