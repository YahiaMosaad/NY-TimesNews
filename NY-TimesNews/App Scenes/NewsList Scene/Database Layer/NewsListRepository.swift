//
//  ItemsListRepository.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 27/01/2022.
//

import Foundation
import Combine

protocol NewsListRepository{
//    var apiKey: String {get}
//    var period: NewsPeriod {get}
    func getNewsList(getNewsListQuery: GetNewsListQuery) -> [NewsFeedData]
}

final class NewsListRepositoryImp: NewsListRepository{
    private var network : HTTPClient
//    var apiKey: String
//    var period: NewsPeriod
    
//    init(apiKey: String, period: NewsPeriod){
//        self.apiKey = apiKey
////        self.period = period
//        print("init NewsListRepositoryImp")
//    }
    
    init (network: HTTPClient){
        self.network = network
    }
    
    func getNewsList(getNewsListQuery: GetNewsListQuery) -> [NewsFeedData] {
        return [NewsFeedData]()
    }
   
}

struct GetNewsListQuery {
    let period: NewsPeriod
    let jsonString: String
    let keyString: String
    let nyTimesKey: String
    
    var value: String {
        return period.rawValue + jsonString + keyString + nyTimesKey
    }
}


#if DEBUG
//final class NewsListRepositoryImpMocked: NewsListRepository{
//    func getNewsList(getNewsListQuery: GetNewsListQuery) -> UseCaseResult<NewsFeed?, GetNewsUseCase.GetNewsUseCaseError> {
//        return UseCaseResult<Any, nil>
//    }
//
//
//    init(){
//        print("init NewsListRepositoryImpMocked")
//    }
//
//}
#endif

