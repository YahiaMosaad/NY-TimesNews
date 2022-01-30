//
//  GetNewsUseCase.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Combine

final class GetNewsUseCase: UseCase{
    
    typealias T = NewsFeed?
    typealias E = GetNewsUseCaseError
    typealias Input = NewsPeriod
    
    //here we add all business logic use cases
    let dependencies: GetNewsUseCaseDependencies
    
    init(dependencies: GetNewsUseCaseDependencies){
        
        self.dependencies = dependencies
        print("init GetNewsUseCase")
    }
    
    func execute(_ period: NewsPeriod?)-> UseCaseResult<NewsFeed?, GetNewsUseCaseError> {

        //request query
        let query = GetNewsListQuery(period: period ?? .week, jsonString: APIParametersKey.json.key, keyString: APIParametersKey.NYTimesAPIKey.key, nyTimesKey: APIParametersValue.NYTimesAPIValue.value)
        return dependencies.newsListRepository.getNewsList(getNewsListQuery: query)
    }
}

extension GetNewsUseCase{
    struct GetNewsUseCaseDependencies{
        let newsListRepository: NewsListRepository
    }
}

extension GetNewsUseCase{//business cases errors
    enum GetNewsUseCaseError: Error{
        case noInternetConnection
        case invalidAPIKey
        case noDataFound
    }
}

extension GetNewsUseCase: Dependant{
    typealias Instance = GetNewsUseCase
    typealias Dependenceis = GetNewsUseCaseDependencies
    static func instance(input: GetNewsUseCaseDependencies) -> GetNewsUseCase {
        return GetNewsUseCase(dependencies: input)
    }
}

#if DEBUG
extension GetNewsUseCase{
    static let mockedUseCase: GetNewsUseCase = .init(dependencies: .init(newsListRepository: NewsListRepositoryImp(network: HTTPClient.defaultClient)))
}
#endif
