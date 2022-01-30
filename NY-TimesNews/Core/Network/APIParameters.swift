//
//  APIParameters.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 27/01/2022.
//

import Foundation
enum APIParametersKey {
    case NYTimesAPIKey
    case json
    var key: String {
        switch self {
        case .NYTimesAPIKey:
            return "api-key="
        case .json:
            return ".json?"
        }
    }
}
enum APIParametersValue {
    case NYTimesAPIValue
    var value: String {
        switch self {
        case .NYTimesAPIValue:
            return "xkNY5aV5vNaAC3bWJ9vrBLfGrkpfHpEF"
        }
    }
}

enum NewsPeriod: String {
    case day = "1"
    case week = "7"
    case month = "30"
}
