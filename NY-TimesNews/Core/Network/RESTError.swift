//
//  RESTError.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation
enum RESTError {
    case invalidRequest(HTTPRequest)
    case invalidResponse(URLResponse)
    case taskError(URLError)
    case jsonDecodeError(Error)

    case emptyResponse
    case http(code: Int, error: String?)

    var serviceMessage: String? {
        switch self {
        case .http(_, error: let error):
            return error
        case .taskError(let error):
            let noInetnetConnection = error.code == .dataNotAllowed || error.code == .notConnectedToInternet
            print(noInetnetConnection ? "No internet connection" : "Connected")
            if noInetnetConnection {
                return "No Internet Connection"
            }
            else{
                return nil
            }
            
        default:
            return nil
        }
    }
    var isNoInternetError: Bool{
        switch self {
        case .taskError(let error):
            return error.code == .dataNotAllowed || error.code == .notConnectedToInternet
        default:
            return false
        }
    }
}

extension RESTError: Error {}

struct ErrorResponse: Codable {
    var errors: [String: [String]]?
    var title: String?
    var status: Int
    var error: String?
    var detail: String?

    var allErrorDescriptions: [String] {
        let descriptions = errors?.reduce([], { (result, keyValue) -> [String] in
            let allValues = keyValue.1.map { [keyValue.0, $0].joined(separator: " : ") }
            return result + allValues
        })

        return descriptions ?? []
    }
}
