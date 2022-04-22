//
//  UIViewController+Extension.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation
import UIKit

extension UIViewController{
    static func instantiate<T>()-> T{
        let storyboardName = "\(T.self)Storyboard".replacingOccurrences(of: "ViewController", with: "View")
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "\(T.self)") as! T
    }
}
