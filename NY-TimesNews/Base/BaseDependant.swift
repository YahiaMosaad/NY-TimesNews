//
//  BaseDependant.swift
//  NY-TimesNews
//
//  Created by Ali Amin on 22/04/2022.
//

import Foundation


protocol BaseDependant {
    associatedtype Dependenceis
    static func instance(input: Dependenceis) -> Self
}
