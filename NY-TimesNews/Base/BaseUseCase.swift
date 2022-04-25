//
//  DependencyInjection.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
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
