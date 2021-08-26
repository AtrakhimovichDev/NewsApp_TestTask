//
//  NewsSettings.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 24.08.21.
//

import UIKit

class NewsPresenter: NewsPresenterProtocol {

    private var news: NewsModel
    weak var viewController: NewsViewControllerProtocol?

    init(viewController: NewsViewControllerProtocol) {
        self.viewController = viewController
        self.news = NewsModel()
    }

    func clearAllNews() {
        news.articles.removeAll()
        news.filteredArticles.removeAll()
    }

    func changeDateToPreviousDay() {
        news.currentNewsDate -= TimeInterval(86400)
        news.daysCount += 1
    }

    func filterArticles(text: String) {
        if text.isEmpty {
            news.filteredArticles = news.articles
        } else {
            news.filteredArticles = news.articles.filter { $0.title.lowercased().contains(text.lowercased()) }
        }
    }

    func needToLoadMoreNews() -> Bool {
        return news.daysCount > 7 ? false : true
    }

    func resetDateSettings() {
        news.currentNewsDate = Date()
        news.daysCount = 1
    }

    func downloadNews(searchText: String?) {
        NetworkRequestManager.getNews(news: news, searchText: searchText) {(news, searchText) in
            for article in news.articles {
                let date = DateFormatterManager.shared.getDateFromString(string: article.publishedAt!)
                let articleModel = ArticleModel(title: article.title!,
                                                url: article.url!,
                                                date: date,
                                                description: article.description,
                                                urlToImage: article.urlToImage)
                self.news.articles.append(articleModel)
            }
            if let searchText = searchText,
               !searchText.isEmpty {
                self.news.filteredArticles = self.news.articles.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }
            } else {
                self.news.filteredArticles = self.news.articles
            }
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.updateTableView()
            }
        }
    }

    func getFilteredArticles() -> [ArticleModel] {
        return news.filteredArticles
    }

    func getNews() -> NewsModel {
        return news
    }
}
