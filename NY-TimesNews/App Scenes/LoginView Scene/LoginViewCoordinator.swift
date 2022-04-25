//
//  LoginViewCoordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 22/04/2022.
//

import UIKit
final class LoginViewCoordinator: Coordinator {
    internal let dependencies: UINavigationController
    
    
    init(dependencies: UINavigationController){
        self.dependencies = dependencies
    }
    
    func start() {
        let view: LoginView = .instantiate()
        view.viewModel = .init(loginUseCase: LoginUseCaseImp(loginRepository: LoginRepositoryMock(network: HTTPClient.defaultClient) as! LoginRepository), routes: .init(showHomeView: showHomeView))
        dependencies.pushViewController(view, animated: true)
    }
    
    func finish() {}
    
    private func showHomeView(){
        
    }
}
