//
//  LoginViewModel.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 22/04/2022.
//

import Foundation

import Combine

final class LoginViewModel: ObservableObject{
    @Published var errorMessage: String?
    @Published var showLoadingIndicator = false
    
    private let loginUseCase: LoginUseCase
    private var cancellables = Set<AnyCancellable>()
    private let routes: LoginViewRoutes
    init(loginUseCase: LoginUseCase, routes: LoginViewRoutes){
        self.loginUseCase = loginUseCase
        self.routes = routes
    }
}

extension LoginViewModel{//view to view model
    func didPressLoginButton(email: String?, poassword: String?){
        showLoadingIndicator = true
        loginUseCase.execute(email: email, password: poassword)
            .sink { [weak self] completionStatus in
                if case let .failure(error) = completionStatus {
                    self?.handleLoginError(error)
                }
                self?.showLoadingIndicator = false
            } receiveValue: { [weak self] loggedInUser in//succesfull login
                self?.showLoadingIndicator = false
                //use case to execute the save user info into keychain
                self?.routes.showHomeView()
            }.store(in: &cancellables)
    }
    
    private func handleLoginError(_ error: LoginUseCaseError){
        switch error {
        case .notAuthorized:
            errorMessage = "You are not authorized"
        case .invalidEmailOrPassword:
            errorMessage = "Invalid email or password"
        case .emailIsMissing:
            errorMessage = "Missing email"
        case .invalidEmail:
            errorMessage = "Invalid email"
        case .missingPassword:
            errorMessage = "Missing password"
        case .tooShortPassword:
            errorMessage = "password too short"
        }
    }
}

struct User: Codable{
    let name: String
}

struct LoginViewRoutes{
    let showHomeView:()->()
}
