//
//  NewsAPIManager.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 19.08.21.
//

import Foundation
import Alamofire

class NewsAPIManager {

    static private var apiKey = "888f3b58079746ef8c68464225f9e143"

    static func getNews(news: NewsModel, searchText: String?, completion: @escaping ((NewsJSON, String?) -> Void)) {

        let date = DateFormatterManager.shared.getStringFromDate(date: news.currentNewsDate)
        let parameters = ["apiKey": apiKey,
                          "q": news.defaultSearchKey,
                          "from": date,
                          "to": date]
        AF.request("https://newsapi.org/v2/everything", parameters: parameters).response { response in
            guard let data = response.data else { return }
            if let news = try? JSONDecoder().decode(NewsJSON.self, from: data) {
                completion(news, searchText)
            }
        }
    }
}
