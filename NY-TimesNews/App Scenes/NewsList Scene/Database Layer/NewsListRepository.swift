//
//  ItemsListRepository.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 27/01/2022.
//

import Foundation
import Combine


final class NewsListRepository: BaseRepository {
    func getNewsList(getNewsListQuery: GetNewsListQuery) -> [NewsFeedData] {
        // Network call
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

