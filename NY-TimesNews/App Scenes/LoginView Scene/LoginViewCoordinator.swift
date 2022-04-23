//
//  LoginViewCoordinator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 22/04/2022.
//

import UIKit
final class LoginViewCoordinator: Coordinator{
    private let navigationController: UINavigationController
    init( navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    func start() {
        let view: LoginView = .instantiate()
        view.viewModel = .init(loginUseCase: LoginUseCaseImp(loginRepository: LoginRepositoryMock()), routes: .init(showHomeView: showHomeView))
        navigationController.pushViewController(view, animated: true)
    }
    private func showHomeView(){
        
    }
}
