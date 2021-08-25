//
//  Article.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 19.08.21.
//

import Foundation

struct ArticleJSON: Decodable {
    let title: String
    let url: String
    let publishedAt: String
    let description: String?
    let author: String?
    let urlToImage: String?
}
