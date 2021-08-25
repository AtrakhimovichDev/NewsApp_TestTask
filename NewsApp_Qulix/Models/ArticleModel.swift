//
//  ArticleModel.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 25.08.21.
//

import Foundation

class ArticleModel {
    let title: String
    let url: String
    let date: Date
    let description: String?
    let urlToImage: String?

    init(title: String, url: String, date: Date, description: String?, urlToImage: String?) {
        self.title = title
        self.url = url
        self.date = date
        self.description = description
        self.urlToImage = urlToImage
    }
}
