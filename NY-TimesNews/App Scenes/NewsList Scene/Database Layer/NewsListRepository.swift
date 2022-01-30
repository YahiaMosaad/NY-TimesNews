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
    func getNewsList(getNewsListQuery: GetNewsListQuery) -> UseCaseResult<NewsFeed?, GetNewsUseCase.GetNewsUseCaseError>
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
    
    func getNewsList(getNewsListQuery: GetNewsListQuery) -> UseCaseResult<NewsFeed?, GetNewsUseCase.GetNewsUseCaseError> {
    
        
        //period.rawValue + APIParametersKey.json.key + APIParametersKey.NYTimesAPIKey.key + apiKey
        
        let publisher:AnyPublisher<NewsFeed, RESTError> = network.request(method: .get, path: [Endpoints.mostviewedAllSections.name + getNewsListQuery.value]).responseJSON()
        
        //mapping remote db model to domain layer model and error
        return publisher
            .map{(news) in
                return news
            }
            .mapError { error -> GetNewsUseCase.GetNewsUseCaseError in
            switch error{
            case .invalidRequest:
                return .noInternetConnection
            default:
                return .noDataFound
            }
        }.eraseToAnyPublisher()
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

