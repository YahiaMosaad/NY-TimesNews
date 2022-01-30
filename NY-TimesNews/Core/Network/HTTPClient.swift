//
//  HTTPClient.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation

struct HTTPClient {
    static private var defaultBaseURL =  APIURLConstants.NYTimesAPIBaseURL
    static var defaultClient: HTTPClient { HTTPClient(baseUrl: defaultBaseURL)! }

    let session: URLSession
    let baseUrl: URLComponents
    var headers: [String: String]?
    var encoder: JSONEncoder
    var decoder: JSONDecoder

    init?(
        session: URLSession = .shared,
        baseUrl: String = HTTPClient.defaultBaseURL,
        headers: [String: String]? = nil,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        guard let baseUrl = URLComponents(string: baseUrl) else { return nil }
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        self.baseUrl = baseUrl
        self.headers = headers
    }

    func get<K: StringConvertible>(_ path: K...) -> HTTPRequest {
        return request(method: .get, path: path)
    }

    func post<K: StringConvertible>(_ path: K...) -> HTTPRequest {
        return request(method: .post, path: path)
    }

    func patch<K: StringConvertible>(_ path: K...) -> HTTPRequest {
        return request(method: .patch, path: path)
    }

    func put<K: StringConvertible>(_ path: K...) -> HTTPRequest {
        return request(method: .put, path: path)
    }

    func delete<K: StringConvertible>(_ path: K...) -> HTTPRequest {
        return request(method: .delete, path: path)
    }

    func request<K: StringConvertible>(method: HTTPRequest.Method, path: [K]) -> HTTPRequest {
        return .init(
            session: session,
            encoder: encoder,
            decoder: decoder,
            baseUrl: baseUrl,
            headersMap: headers,
            method: method,
            pathComponents: path.map { $0.stringValue },
            paramsMap: nil
        )
    }

    func request(method: HTTPRequest.Method, pathComponents: [StringConvertible]) -> HTTPRequest {
        return .init(
            session: session,
            encoder: encoder,
            decoder: decoder,
            baseUrl: baseUrl,
            headersMap: headers,
            method: method,
            pathComponents: pathComponents.map { $0.stringValue },
            paramsMap: nil
        )
    }

}
