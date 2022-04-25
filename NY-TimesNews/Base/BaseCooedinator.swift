//
//  BaseCooedinator.swift
//  NY-TimesNews
//
//  Created by Ali Amin on 25/04/2022.
//

import Foundation


protocol BaseCoordinator {
    associatedtype T


    var dependencies: T { get }

    func start()
    func finish()
}
