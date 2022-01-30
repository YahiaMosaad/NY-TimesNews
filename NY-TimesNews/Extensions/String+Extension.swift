//
//  String+Extension.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation

protocol StringConvertible {
    var stringValue: String { get }
}
extension String: StringConvertible {
    var stringValue: String {
        return self
    }
}
