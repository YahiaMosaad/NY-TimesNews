//
//  Dependant.swift
//  NY-TimesNews
//
//  Created by Ali Amin on 25/04/2022.
//

import Foundation


protocol Dependant {
    associatedtype Dependenceis
    static func instance(input: Dependenceis) -> Self
}

