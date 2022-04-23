//
//  LoginRepository.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 22/04/2022.
//

import Combine

struct LoginQuery: Codable{
    let email: String
    let password: String
}

protocol LoginRepository{
    func login(query: LoginQuery)-> AnyPublisher<User, LoginUseCaseError>
}

final class LoginRepositoryMock: LoginRepository{
    func login(query: LoginQuery) -> AnyPublisher<User, LoginUseCaseError> {
        Just(User(name: "Yahia")).setFailureType(to: LoginUseCaseError.self)
            .eraseToAnyPublisher()
    }
}
