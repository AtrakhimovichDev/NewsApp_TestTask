//
//  ViewController.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 19.08.21.
//

import UIKit

class NewsViewController: UIViewController, NewsViewControllerProtocol {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var newsTableView: UITableView!

    var newsPresenter: NewsPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNewsPresenter()
        setupViewControllerSettings()
        setupTableViewSettings()
        newsPresenter.downloadNews(searchText: nil)
    }

    private func setupNewsPresenter() {
        newsPresenter = NewsPresenter(viewController: self)
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

    func updateTableView() {
        self.newsTableView.tableFooterView = nil
        self.newsTableView.refreshControl?.endRefreshing()
        self.newsTableView.reloadData()
    }

    private func clearTableView() {
        newsPresenter.clearAllNews()
        newsTableView.reloadData()
    }

    @objc private func singleTap() {
        self.searchBar.endEditing(true)
    }

    @objc private func updateData() {
        clearTableView()
        newsPresenter.resetDateSettings()
        newsPresenter.downloadNews(searchText: searchBar.text)
    }
}

extension NewsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsPresenter.getFilteredArticles().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = String(describing: NewsTableViewCell.self)
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        let article = newsPresenter.getFilteredArticles()[indexPath.row]
        cell.setupCell(article: article)
        cell.fillTableCell(article: article, news: newsPresenter.getNews())
        return cell
    }
}

extension NewsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == newsPresenter.getFilteredArticles().count - 1 {
            newsPresenter.changeDateToPreviousDay()
            if newsPresenter.needToLoadMoreNews() {
                setupActivityIndicator()
                newsPresenter.downloadNews(searchText: searchBar.text)
            }
        }
    }

    private func setupActivityIndicator() {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: newsTableView.bounds.width, height: CGFloat(44))

        self.newsTableView.tableFooterView = spinner
        self.newsTableView.tableFooterView?.isHidden = false
    }
}

extension NewsViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        newsPresenter.filterArticles(text: searchText)
        self.newsTableView.reloadData()
    }
}
