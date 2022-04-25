//
//  GetNewsUseCase.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Combine

protocol GetNewsUseCase{
    func execute(_ period: NewsPeriod?)-> [NewsFeedData]
}

final class GetNewsUseCaseImp: GetNewsUseCase{
    
    //here we add all business logic use cases
//    let dependencies: GetNewsUseCaseDependencies
    
//    init(dependencies: GetNewsUseCaseDependencies){
//        self.dependencies = dependencies
//        print("init GetNewsUseCase")
//    }
    private let newsListRepository: NewsListRepository
    init(newsListRepository: NewsListRepository){
        self.newsListRepository = newsListRepository
        print("init GetNewsUseCase")
    }
    
    func execute(_ period: NewsPeriod?)-> [NewsFeedData] {
        let query = GetNewsListQuery(period: period ?? .week, jsonString: APIParametersKey.json.key, keyString: APIParametersKey.NYTimesAPIKey.key, nyTimesKey: APIParametersValue.NYTimesAPIValue.value)
        return newsListRepository.getNewsList(getNewsListQuery: query)
    }
    
//    func execute(_ period: NewsPeriod?)-> UseCaseResult<NewsFeed?, GetNewsUseCaseError> {
//
//        //request query
//        let query = GetNewsListQuery(period: period ?? .week, jsonString: APIParametersKey.json.key, keyString: APIParametersKey.NYTimesAPIKey.key, nyTimesKey: APIParametersValue.NYTimesAPIValue.value)
//        return dependencies.newsListRepository.getNewsList(getNewsListQuery: query)
//    }
}

//extension GetNewsUseCase{
//    struct GetNewsUseCaseDependencies{
//        let newsListRepository: NewsListRepository
//    }
//}

//business cases errors
enum GetNewsUseCaseError: Error{
    case noInternetConnection
    case invalidAPIKey
    case noDataFound
}

//extension GetNewsUseCase: Dependant{
//    typealias Instance = GetNewsUseCase
//    typealias Dependenceis = GetNewsUseCaseDependencies
//    static func instance(input: GetNewsUseCaseDependencies) -> GetNewsUseCase {
//        return GetNewsUseCase(dependencies: input)
//    }
//}

#if DEBUG
final class GetNewsUseCaseMock: GetNewsUseCase{
    func execute(_ period: NewsPeriod?)-> [NewsFeedData] {
        return [NewsFeedData]()
    }
}
#endif
