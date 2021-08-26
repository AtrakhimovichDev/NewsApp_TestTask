//
//  NewsPresenter.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 25.08.21.
//

import Foundation

protocol NewsPresenterProtocol {
    func downloadNews(searchText: String?)
    func resetDateSettings()
    func clearAllNews()
    func changeDateToPreviousDay()
    func filterArticles(text: String)
    func needToLoadMoreNews() -> Bool
    func getNews() -> NewsModel
    func getFilteredArticles() -> [ArticleModel]
}
