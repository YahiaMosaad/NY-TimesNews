//
//  ParamEncoding.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation
class ParamEncoding {
    var components: [URLQueryItem] = []

    func encode(params: [String: Any]) {
        for (key, value) in params {
            encodeAny(key: key, value: value)
        }
        components.sort(by: { $0.name < $1.name })
    }

    func encodeAny(key: String, value: Any) {
        switch value {
        case let stringValue as String: encodeString(key: key, value: stringValue)
        case let boolValue as Bool: encodeBool(key: key, value: boolValue)
        case let numberValue as NSNumber: encodeNumber(key: key, value: numberValue)
        case let arrayValue as [Any]: encodeArray(key: key, value: arrayValue)
        case let mapValue as [String: Any]: encodeMap(key: key, value: mapValue)
        default:
            encodeObj(key: key, value: value)
        }
    }

    func encodeString(key: String, value: String) {
        components.append(.init(name: key, value: value))
    }

    func encodeBool(key: String, value: Bool) {
        encodeString(key: key, value: value ? "1" : "0")
    }

    func encodeNumber(key: String, value: NSNumber) {
        encodeString(key: key, value: value.stringValue)
    }

    func encodeObj(key: String, value: Any) {
        encodeString(key: key, value: String(describing: value))
    }

    func encodeArray(key: String, value: [Any]) {
        for element in value {
            encodeAny(key: "\(key)[]", value: element)
        }
    }

    func encodeMap(key: String, value: [String:Any]) {
        for (nestedKey, nestedValue) in value {
            encodeAny(key: "\(key)[\(nestedKey)]", value: nestedValue)
        }
    }
}
