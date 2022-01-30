//
//  Coordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation

protocol Coordinator: AnyObject{
    var childCoordinators: [Coordinator] {get set}
    func start()
    func finish()
    func addChildCoordinator<T: Coordinator>(_ coordinator: T)
    func removeChildCoordinator<T: Coordinator>(_ coordinator: T)
    func removeAllChildCoordinatorsWith<CC>(type: CC.Type)
    func removeAllChildCoordinators()
}
extension Coordinator{
    func removeAllChildCoordinatorsWith<CC>(type: CC.Type){
        childCoordinators.removeAll(where: {$0 is CC == false})
    }
    func removeAllChildCoordinators(){
        childCoordinators.removeAll()
    }
    func removeChildCoordinator<T: Coordinator>(_ coordinator: T){
        childCoordinators.removeAll(where: {$0 === coordinator})
    }
    func addChildCoordinator<T: Coordinator>(_ coordinator: T){
        childCoordinators.append(coordinator)
    }
}
