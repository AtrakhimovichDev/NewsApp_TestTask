//
//  News.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 19.08.21.
//

import Foundation

struct News: Decodable {
    let status: String
    let articles: [Article]
}
