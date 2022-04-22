//
//  NewsDetailsView.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 28/01/2022.
//

import UIKit
import Combine

final class NewsDetailsView: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDetailsTextView: UITextView!
    
    // MARK: Instance
    var viewModel: NewsDetailsViewModel!
    private var cancellables: Set<AnyCancellable> = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        bindTo(viewModel)
    }
    private func bindTo(_ viewModel: NewsDetailsViewModel){
        viewModel.$newsDetails
            .receive(on: RunLoop.main)
            .sink{ [weak self] details in
            guard let newsDetails = details else {
                return
            }
                self?.fillData(with: newsDetails)
        }.store(in: &cancellables)
    }
    
    private func fillData(with newsDetais: NewsFeedData) {
        newsTitleLabel.text = newsDetais.title
        newsDetailsTextView.text = newsDetais.abstract
        
        guard let imageURL = newsDetais.largeImageURL else {
            return
        }
        newsImageView.load(url: URL(string: imageURL)!)

    }
    deinit{
        _ = cancellables.map{$0.cancel()}//cancel all observers
    }
    

}
extension NewsDetailsView: BaseDependant {
    typealias Dependenceis = NewsDetailsViewModel
    
    static func instance(input: Dependenceis) -> NewsDetailsView {
        let instance: NewsDetailsView = .instantiate()
        print("init NewsDetailsView")
        instance.viewModel = input
        return instance
    }
}


