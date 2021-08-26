//
//  NewsAPIManager.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 19.08.21.
//

import Foundation
import Alamofire

class NetworkRequestManager {

    static private var apiKey = "5fffb6bbeb4548b1bdc66d4f38a405b1"

    static func getNews(news: NewsModel, searchText: String?, completion: @escaping ((NewsJSON, String?) -> Void)) {

        let date = DateFormatterManager.shared.getStringFromDate(date: news.currentNewsDate)
        let parameters = ["apiKey": apiKey,
                          "q": news.defaultSearchKey,
                          "from": date,
                          "to": date]
        if NetworkReachabilityManager()?.isReachable ?? false {
            AF.request("https://newsapi.org/v2/everything", parameters: parameters).response { response in
                switch response.result {
                case .success:
                    guard let data = response.data else { return }
                    do {
                        let news = try JSONDecoder().decode(NewsJSON.self, from: data)
                        completion(news, searchText)
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print("error: \(error)")
                }
            }
        } else {
            print("Network dead")
        }
    }

    static func downloadImage(urlString: String?, completion: @escaping ((UIImage?, Image?) -> Void)) {
        if let imageURLString = urlString,
           !imageURLString.isEmpty {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    guard let URLImage = URL(string: imageURLString) else { return }
                    let data = try Data(contentsOf: URLImage)
                    guard let uiImage = UIImage(data: data) else { return }

                    let imageName = "\(Date().timeIntervalSince1970).png"
                    FilesManager.shared.saveImage(image: uiImage, imageName: imageName)

                    let imageObj = Image(localeName: imageName, imageURL: imageURLString)
                    completion(uiImage, imageObj)
                } catch {
                    print(error.localizedDescription)
                    completion(nil, nil)
                }
            }
        }
    }
}
