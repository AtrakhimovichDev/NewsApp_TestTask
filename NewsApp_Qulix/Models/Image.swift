//
//  Image.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 19.08.21.
//

import Foundation

class Image {
    let localeName: String
    let imageURL: String

    init(localeName: String, imageURL: String) {
        self.imageURL = imageURL
        self.localeName = localeName
    }
}
