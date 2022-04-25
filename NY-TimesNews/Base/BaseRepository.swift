//
//  BaseRepository.swift
//  NY-TimesNews
//
//  Created by Ali Amin on 23/04/2022.
//

import Foundation


class BaseRepository {
    var network : HTTPClient
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
}
