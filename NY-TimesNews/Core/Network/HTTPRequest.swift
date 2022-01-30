//
//  HTTPRequest.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation
import Combine
import UIKit

typealias RestPublisher<T> = AnyPublisher<T, RESTError>

struct HTTPRequest {
    let APPLICATION_JSON = "application/json"
    let APPLICATION_PATCH_JSON = "application/json-patch+json"

    enum Method: String {
        case get, post, patch, put, delete

        var value: String { self.rawValue.uppercased() }
    }

    let session: URLSession
    let encoder: JSONEncoder
    let decoder: JSONDecoder

    var baseUrl: URLComponents
    var headersMap: [String:String]?
    var method: Method
    var pathComponents: [String]
    var paramsMap: [String: Any]?
    var jsonBody: Data?
//    var token: String? { KeychainManager.token }

    func path<K: StringConvertible>(_ path: K) -> HTTPRequest {
        var request = self
        request.pathComponents.append(path.stringValue)
        return request
    }

    func params(_ paramsMap: [String: Any]) -> HTTPRequest {
        var request = self
        request.paramsMap?.merge(paramsMap, uniquingKeysWith: { $1 })
        if request.paramsMap == nil {
            request.paramsMap = paramsMap
        }
        return request
    }

    func headers(_ headersMap: [String: String]) -> HTTPRequest {
        var request = self
        request.headersMap?.merge(headersMap, uniquingKeysWith: { $1 })
        if request.headersMap == nil {
            request.headersMap = headersMap
        }
        return request
    }

//    func authorized() -> HTTPRequest {
//        return token.flatMap{ headers(["Authorization": "Bearer " + $0]) } ?? self
//    }

    func body<T: Codable>(_ json: T) -> HTTPRequest {
        var request = self
        request.jsonBody = try? encoder.encode(json)
        return request.headers(["Content-Type": APPLICATION_PATCH_JSON])
    }

    func accept(_ contentType: String) -> HTTPRequest {
        return headers(["Accept": contentType])
    }

    func responseJSON<T: Decodable>() -> RestPublisher<T> {
        return accept(APPLICATION_JSON).dataPublisher.flatMap { (element) -> AnyPublisher<T, RESTError>  in
            guard let data = element else {
                return fail(.emptyResponse)
            }
            do {
                return just(try self.decoder.decode(T.self, from: data))
            } catch (let error) {
                #if DEBUG
                print(error)
                #endif
                return fail(.jsonDecodeError(error))
            }
        }.eraseToAnyPublisher()
    }

    func multipartFormBody(parameters: [[String: String]], boundary: String) -> HTTPRequest {
        var body = ""
        for param in parameters {
            let paramName = param["name"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            if let fileName = param["file_name"] {
                let contentType = param["content_type"]!
                let fileContent = param["file_content"]!
                body += "; filename=\"\(fileName)\"\r\n"
                body += "Content-Type: \(contentType)\r\n\r\n"
                body += fileContent
            } else if let paramValue = param["value"] {
                body += "\r\n\r\n\(paramValue)"
            }
        }

        let headers = [
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
            "Content-Length": String(body.count)
        ]
        var request = self
        request.jsonBody = body.data(using: .utf8)
        return request.headers(headers)
    }

    func multipartFormBody(for image: UIImage) -> HTTPRequest {
        let imageData = image.jpegData(compressionQuality: 0.7)

        var request = self
        let imageMultipartForm = ImageMultipartForm(imageData: imageData)
        request.jsonBody = imageMultipartForm.body

        return request.headers(imageMultipartForm.headers)
    }

    func response() -> RestPublisher<Void> {
        return dataPublisher.map { _ in }.eraseToAnyPublisher()
    }
}

fileprivate extension HTTPRequest {
    var dataPublisher: RestPublisher<Data?> {
        guard let taskPublisher = taskPublisher else {
            return Fail(error: RESTError.invalidRequest(self)).eraseToAnyPublisher()
        }

        return taskPublisher
            .mapError {
                RESTError.taskError($0)
            }
            .flatMap { (element) -> AnyPublisher<Data?, RESTError> in
                guard let response = element.response as? HTTPURLResponse else {
                    return fail(.invalidResponse(element.response))
                }
                let code = response.statusCode
                switch code {
                    case 200, 201:
                        return just(element.data)
                    case 204:
                        return just(nil)
                    default:
                        let error = try? self.decoder.decode(ErrorResponse.self, from: element.data)
                        var description = error?.detail
                        #if DEBUG
                        description = [description, "\n#DEBUG#", error?.allErrorDescriptions.first, error?.detail]
                            .compactMap{ $0 }
                            .joined(separator: "\n")
                        print("---Resonse error--------------------------------------------------------")
                    print(description ?? "")
                        print("------------------------------------------------------------------------")
                        #endif
                        return fail(.http(code: code, error: description))
                }
            }.eraseToAnyPublisher()
    }

    var taskPublisher: URLSession.DataTaskPublisher? {
        guard let request = request else { return nil }
        return session.dataTaskPublisher(for: request)
    }

    var request: URLRequest? {
        guard let url = URL(string: urlString ?? "") else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        request.allHTTPHeaderFields = headersMap
        if method == .post || method == .patch || method == .put || method == .delete{
            request.httpBody = httpBody
        }
        return request
    }

    var urlString: String? {
        var components = self.baseUrl
        if method != .post {
            components.queryItems = queryItems
        }
        guard let url = components.url else { return nil }
        print(pathComponents)
        var urlStr: String = url.absoluteString
        pathComponents.forEach {
            urlStr += $0
        }
        return urlStr
    }
    var url: URL? {
        var components = self.baseUrl
        if method != .post {
            components.queryItems = queryItems
        }

        guard var url = components.url else { return nil }
        print(pathComponents)
        pathComponents.forEach {
            url.appendPathComponent($0)
        }
        return url
    }

    var httpBody: Data? {
        return jsonBody ?? queryItems.flatMap { items in
            var components = self.baseUrl
            components.queryItems = items
            return components.url?.query.map { Data($0.utf8) }
        }
    }

    var queryItems: [URLQueryItem]? {
        return paramsMap.map {
            let encoding = ParamEncoding()
            encoding.encode(params: $0)
            return encoding.components
        }
    }
}

fileprivate func fail<Output>(_ error: RESTError) -> AnyPublisher<Output, RESTError> {
    Fail(error: error).eraseToAnyPublisher()
}

fileprivate  func just<Output>(_ data: Output) -> AnyPublisher<Output, RESTError> {
    Just(data).setFailureType(to: RESTError.self).eraseToAnyPublisher()
}


struct ImageMultipartForm {
    let boundary = "Boundary-\(UUID().uuidString)"
    var imageData: Data? = nil
    var fileName: String = "image.jpeg"
    var headers: [String: String] {[ "Content-Type": "multipart/form-data; boundary=\(boundary)"]}

    private var prefix: String { "--\(boundary)\r\n" }
    private var disposition: String { "Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n" }
    private var type: String { "Content-Type: image/jpg\r\n\r\n" }
    private var suffix: String { "\r\n--\(boundary)--\r\n" }

    var body: Data {
        var body = Data()
        body.appendString(prefix)
        body.appendString(disposition)
        body.appendString(type)
        imageData.map { body.append($0) }
        body.appendString(suffix)

        return body
    }
}


extension RawRepresentable where RawValue: StringConvertible {
    var stringValue: String {
        return rawValue.stringValue
    }
}
