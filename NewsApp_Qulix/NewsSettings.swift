//
//  NewsSettings.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 24.08.21.
//

import UIKit

class NewsSettings {

    var newsDate = Date()
    var daysCount = 1
    var defaultSearchKey = "world news"
    var articles = [Article]()
    var filteredArticles = [Article]()

    var loadDataComplition: ((News) -> Void)?
    var updateTableViewComplition: (() -> Void)?

    var images = [Image]() {
        didSet {
            DispatchQueue.main.async {
                if let complition = self.updateTableViewComplition {
                    complition()
                }
            }
        }
    }

    init() {
        loadDataComplition = { news in
            self.articles += news.articles
            self.filteredArticles = self.articles
            DispatchQueue.main.async {
                if let complition = self.updateTableViewComplition {
                    complition()
                }
            }
            self.downloadImages(articles: news.articles)
        }
    }

    func clearAllNews() {
        articles.removeAll()
        filteredArticles.removeAll()
    }

    func changeDateToPreviousDay() {
        newsDate -= TimeInterval(86400)
        daysCount += 1
    }

    func filterArticles(text: String) {
        if text.isEmpty {
            filteredArticles = articles
        } else {
            filteredArticles = articles.filter { $0.title.lowercased().contains(text.lowercased()) }
        }
    }

    func needToLoadMoreNews() -> Bool {
        if daysCount > 7 {
            return false
        } else {
            return true
        }
    }

    func resetDateSettings() {
        newsDate = Date()
        daysCount = 1
    }

    private func downloadImages(articles: [Article]) {
        for article in articles {
            if let imageURLString = article.urlToImage {
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let URLImage = URL(string: imageURLString)
                        let data = try Data(contentsOf: URLImage!)
                        let uiImage = UIImage(data: data)

                        let imageName = "\(Date().timeIntervalSince1970).png"
                        FilesManager.shared.saveImage(image: uiImage!, imageName: imageName)

                        let imageObj = Image(localeName: imageName, imageURL: imageURLString)
                        self.images.append(imageObj)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

}
