//
//  NewsListView.swift
//  NY-TimesNews
//
//  Created by Yahia Mosaad on 26/01/2022.
//

import UIKit
import Combine

final class NewsListViewController: UIViewController, LoadableIndicator{
    // MARK: - Outlets
    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!

    var viewModel: NewsListViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindTo(viewModel)//view is reactive to view model events
        viewModel.viewDidLoad()//let viewmodel knows that view has loaded successfully
    }
    private func setupView(){
        self.segmentControl.selectedSegmentIndex = 1
        self.resetUIView()
        newsTableView.dataSource = self
        newsTableView.delegate = self
    }
    private func resetUIView () {
        self.retryButton.isHidden = true
        self.newsTableView.isHidden = true
        self.errorView.isHidden = true
    }
    @IBAction func retryBtnTapped(sender: UIButton) {
        viewModel.viewDidLoad()//let viewmodel knows that view has loaded successfully
    }
    
    private func bindTo(_ viewModel: NewsListViewModel){
        bindViewStates(toEvent: .showLoadingIndicator)
        bindViewStates(toEvent: .showNewsFeed)
        bindViewStates(toEvent: .showErrorMessage)
    }

    private func bindViewStates(toEvent event: NewsListEvents){
        switch event {
        case .showNewsFeed:
            guard let news = viewModel.newsList, news.count > 0 else {
                return
            }
                    
            newsTableView.isHidden = false
//                self?.newsTableView.reloadData()
            reloadTableWithAnimation()
            
        case .showLoadingIndicator:
            showLoadingIndicator(show: viewModel.showLoadingIndicator)
            
        case .showErrorMessage:
            errorLabel.text = viewModel.errorMessag
        }
    }
        
    deinit{
        _ = cancellables.map{$0.cancel()}//cancel all observers
    }
    
    private func reloadTableWithAnimation() {
        newsTableView.reloadSections([0], with: UITableView.RowAnimation.fade)
        newsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    private enum NewsListEvents{
        case showNewsFeed
        case showLoadingIndicator
        case showErrorMessage
    }
}

extension NewsListViewController: BaseDependant {
    typealias Dependenceis = NewsListViewModel

    static func instance(input: Dependenceis) -> NewsListViewController {
        let instance: NewsListViewController = .instantiate()
        instance.viewModel = input
        return instance
    }
}


extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.newsList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.reuseIdentifier, for: indexPath) as? NewsListCell else {
            assertionFailure("Cannot dequeue reusable cell \(NewsListCell.self) with reuseIdentifier: \(NewsListCell.reuseIdentifier)")
            return UITableViewCell()
        }
        guard let item = viewModel.newsList?[indexPath.row] else {
            return cell
        }
        cell.fillNewsData(newsItem: item)
        return cell
    }
    
    
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectNews(at: indexPath.row)
    }
}


extension NewsListViewController {
    @IBAction func indexChanged(_ sender: Any) {
        self.resetUIView()
        viewModel.didChangeSegementValue(segement: NewsListViewSegment(rawValue: segmentControl.selectedSegmentIndex)!)
    }
}

enum NewsListViewSegment : Int{
    case day
    case week
    case month
}
