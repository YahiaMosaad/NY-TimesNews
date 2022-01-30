//
//  Data+Entension.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation

extension Data{
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8, allowLossyConversion: false) {
            self.append(data)
        }
    }
}
