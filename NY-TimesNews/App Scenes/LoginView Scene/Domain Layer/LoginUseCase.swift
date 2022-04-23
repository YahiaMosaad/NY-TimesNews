//
//  LoginUseCase.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 22/04/2022.
//

import Combine

final class LoginUseCaseImp: LoginUseCase{
    private let loginRepository: LoginRepository
    init(loginRepository: LoginRepository){
        self.loginRepository = loginRepository
    }
    func execute(email: String?, password: String?)-> AnyPublisher<User, LoginUseCaseError>{
        guard let email = email, !email.isEmpty else {
            return Fail(error: .emailIsMissing).eraseToAnyPublisher()
        }
        guard isValidEmail(email) else {
            return Fail(error: .invalidEmail).eraseToAnyPublisher()
        }
        guard let password = password, !password.isEmpty else {
            return Fail(error: .missingPassword).eraseToAnyPublisher()
        }
        return loginRepository.login(query: .init(email: email, password: password))
    }
    
    private func isValidEmail(_ email: String)-> Bool{
        return true
    }
}

enum LoginUseCaseError: Error{
    case notAuthorized, invalidEmailOrPassword, emailIsMissing, invalidEmail, missingPassword, tooShortPassword
}

protocol LoginUseCase{
    func execute(email: String?, password: String?)-> AnyPublisher<User, LoginUseCaseError>
}

final class YahiaLoginUseCase: LoginUseCase{
    func execute(email: String?, password: String?) -> AnyPublisher<User, LoginUseCaseError> {
        return Just(User(name: "Yahia")).setFailureType(to: LoginUseCaseError.self).eraseToAnyPublisher()
    }
}
