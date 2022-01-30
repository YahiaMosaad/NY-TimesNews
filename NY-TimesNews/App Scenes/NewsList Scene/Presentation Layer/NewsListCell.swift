//
//  NewsListCell.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 27/01/2022.
//

import UIKit

class NewsListCell: UITableViewCell {
    static let reuseIdentifier = String(describing: NewsListCell.self)

    // MARK: - Outlets
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newsImageView.layer.borderWidth = 1
        newsImageView.layer.masksToBounds = false
        newsImageView.layer.borderColor = UIColor.lightGray.cgColor
        newsImageView.layer.cornerRadius = newsImageView.frame.height/2
        newsImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillNewsData(newsItem: NewsFeedData) {
        newsTitleLabel.text = newsItem.title
        newsDescriptionLabel.text = newsItem.abstract
        newsDateLabel.text = newsItem.publishedDate
        self.loadNewsImage(from: newsItem.standradThumbnailURL)
    }
    

    private func loadNewsImage(from URLString: String?) {
        guard let thumnailURL = URLString else {
            return
        }
        newsImageView.load(url: URL(string: thumnailURL)!)

    }
}
