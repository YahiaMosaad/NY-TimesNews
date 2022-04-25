//
//  UseCase.swift
//  NY-TimesNews
//
//  Created by Ali Amin on 25/04/2022.
//

//protocol Dependant: AnyObject{
//    associatedtype Dependenceis
//    static func instance(input: Dependenceis) -> Self
//}
//domain layer to presentation layer
//Any use case should conform to the use case protocol
protocol UseCase{
    associatedtype Input
    associatedtype Output
    associatedtype T

    var dependencies: T { get }


    func execute(_: Input?)-> Output
}
