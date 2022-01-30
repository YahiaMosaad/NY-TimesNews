//
//  LoadableIndicator.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import Foundation
import UIKit

protocol LoadableIndicator{
    func showLoadingIndicator(show: Bool)
}

extension LoadableIndicator where Self: UIViewController{
    func showLoadingIndicator(show: Bool){
        if show {
            showLoadingIndicator()
        }
        else{
            hideLoadingIndicator()
        }
    }
    
    func showLoadingIndicator(){
        guard !self.view.subviews.contains(where: {$0 is UIProgressView}) else{
            return
        }
        let frame = CGRect(origin: self.view.center, size: CGSize(width: 30.0, height: 30.0))
        let loadingIndicator = UIActivityIndicatorView(frame: frame)
        loadingIndicator.style = .medium
        self.view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        _ = self.view.subviews.map{
            if $0 is UIActivityIndicatorView {
                $0.removeFromSuperview()
            }
        }
    }
}
