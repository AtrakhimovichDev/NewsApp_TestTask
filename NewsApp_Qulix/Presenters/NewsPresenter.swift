//
//  NewsSettings.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 24.08.21.
//

import UIKit

class NewsPresenter: NewsPresenterProtocol {

    private var news: NewsModel
    private var loadDataCompletion: ((NewsJSON, String?) -> Void)?
    weak var viewController: NewsViewControllerProtocol?

    init(viewController: NewsViewControllerProtocol) {
        self.viewController = viewController
        self.news = NewsModel()
        self.loadDataCompletion = { (news, searchText) in
            for article in news.articles {
                let date = DateFormatterManager.shared.getDateFromString(string: article.publishedAt)
                let articleModel = ArticleModel(title: article.title,
                                                url: article.url,
                                                date: date,
                                                description: article.description,
                                                urlToImage: article.urlToImage)
                self.news.articles.append(articleModel)
            }
            if let searchText = searchText,
               !searchText.isEmpty {
                self.news.filteredArticles = self.news.articles.filter { $0.title.lowercased().contains(searchText.lowercased()) }
            } else {
                self.news.filteredArticles = self.news.articles
            }
            DispatchQueue.main.async { [weak self] in
                self?.viewController?.updateTableView()
            }
            self.downloadImages(articles: news.articles)
        }
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
        NewsAPIManager.getNews(news: news, searchText: searchText, completion: loadDataCompletion!)
    }

    func getFilteredArticles() -> [ArticleModel] {
        return news.filteredArticles
    }

    func getImages() -> [Image] {
        return news.images
    }

    private func downloadImages(articles: [ArticleJSON]) {
        for article in articles {
            if let imageURLString = article.urlToImage {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    do {
                        let URLImage = URL(string: imageURLString)
                        let data = try Data(contentsOf: URLImage!)
                        let uiImage = UIImage(data: data)

                        let imageName = "\(Date().timeIntervalSince1970).png"
                        FilesManager.shared.saveImage(image: uiImage!, imageName: imageName)

                        let imageObj = Image(localeName: imageName, imageURL: imageURLString)
                        self?.news.images.append(imageObj)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

}
