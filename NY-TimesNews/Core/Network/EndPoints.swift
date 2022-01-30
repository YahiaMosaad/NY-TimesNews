//
//  EndPoints.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation
enum Endpoints {
    case mostviewed
    case mostviewedAllSections
     var name: String {
        switch self {
        case .mostviewed:
            return "mostviewed/"
        case .mostviewedAllSections:
            return "mostviewed/all-sections/"
        }
    }
    var url: String {
        switch self {
        case .mostviewed:
            return APIURLConstants.NYTimesAPIBaseURL + name
        case .mostviewedAllSections:
            return APIURLConstants.NYTimesAPIBaseURL + name
        }
    }
}
