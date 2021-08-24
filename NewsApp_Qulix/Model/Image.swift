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
    let loaded: Bool = false

    internal init(localeName: String, imageURL: String) {
        self.imageURL = imageURL
        self.localeName = localeName
    }
}
