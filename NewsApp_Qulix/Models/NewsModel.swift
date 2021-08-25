//
//  Article.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 25.08.21.
//

import Foundation

class NewsModel {
    var currentNewsDate = Date()
    var daysCount = 1
    var defaultSearchKey = "world news"
    var articles = [ArticleModel]()
    var filteredArticles = [ArticleModel]()
    var images = [Image]()
}
