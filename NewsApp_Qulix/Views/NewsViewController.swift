//
//  ViewController.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 19.08.21.
//

import UIKit

class NewsViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var newsTableView: UITableView!

    private var newsSettings: NewsPresenter!
    private var isSearchActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewsSettings()
        setupViewControllerSettings()
        setupTableViewSettings()
        NewsAPIManager.getNews(newsSettings: newsSettings)
    }

    private func setupNewsSettings() {
        newsSettings = NewsPresenter()
        newsSettings.updateTableViewCompletion = { [weak self] in
            self?.newsTableView.tableFooterView = nil
            self?.newsTableView.refreshControl?.endRefreshing()
            self?.newsTableView.reloadData()
        }
    }

    private func setupViewControllerSettings() {
        searchBar.delegate = self
        FilesManager.shared.deleteAllImages()
    }

    private func setupTableViewSettings() {
        let nibName = String(describing: NewsTableViewCell.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        let reuseIdentifier = String(describing: NewsTableViewCell.self)
        newsTableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.refreshControl = UIRefreshControl()
        newsTableView.refreshControl?.addTarget(self, action: #selector(updateData), for: .valueChanged)
        newsTableView.addGestureRecognizer(createOutOfSerchTap())
    }

    private func createOutOfSerchTap() -> UITapGestureRecognizer {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        return singleTapGestureRecognizer
    }

    @objc private func singleTap() {
        isSearchActive = false
        self.searchBar.endEditing(true)
    }

    @objc private func updateData() {
        clearTableView()
        newsSettings.resetDateSettings()
        NewsAPIManager.getNews(newsSettings: newsSettings)
    }

    private func clearTableView() {
        newsSettings.clearAllNews()
        newsTableView.reloadData()
    }
}

extension NewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsSettings.filteredArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = String(describing: NewsTableViewCell.self)
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let article = newsSettings.filteredArticles[indexPath.row]
        cell.fillTableCell(article: article, images: newsSettings.images)
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsSettings.filteredArticles.count - 1 && !isSearchActive {
            newsSettings.changeDateToPreviousDay()
            if newsSettings.needToLoadMoreNews() {
                setupActivityIndicator()
                searchBar.text = ""
                NewsAPIManager.getNews(newsSettings: newsSettings)
            }
        }
    }

    private func setupActivityIndicator() {
        let spinner = UIActivityIndicatorView()
        spinner.style = .medium
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: newsTableView.bounds.width, height: CGFloat(44))

        self.newsTableView.tableFooterView = spinner
        self.newsTableView.tableFooterView?.isHidden = false
    }
}

extension NewsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        searchBar.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = true
        newsSettings.filterArticles(text: searchText)
        self.newsTableView.reloadData()
    }
}
