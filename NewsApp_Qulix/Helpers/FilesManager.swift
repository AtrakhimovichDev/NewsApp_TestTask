//
//  FilesManager.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 19.08.21.
//

import UIKit

class FilesManager {

    static let shared = FilesManager()

    private let fileManager = FileManager.default
    private lazy var mainDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private lazy var imagesDirectoryURL = mainDirectoryURL.appendingPathComponent("Images")

    func saveImage(image: UIImage, imageName: String) {
        guard let imageData = image.pngData() else {
            return
        }
        if fileManager.fileExists(atPath: imagesDirectoryURL.path) == false {
            try? fileManager.createDirectory(atPath: imagesDirectoryURL.path,
                                             withIntermediateDirectories: true, attributes: [:])
        }
        let imageURl = imagesDirectoryURL.appendingPathComponent(imageName)
        fileManager.createFile(atPath: imageURl.path, contents: imageData, attributes: [:])
    }

    func getImage(image: Image) -> UIImage {
        let mainDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imageDirectoryURL = mainDirectoryURL.appendingPathComponent("Images")
        let imageURL = imageDirectoryURL.appendingPathComponent(image.localeName)

        if fileManager.fileExists(atPath: imageURL.path) {
            return UIImage(contentsOfFile: imageURL.path) ?? UIImage()
        } else {
            return UIImage(named: "default-news-image") ?? UIImage()
        }
    }

    func deleteAllImages() {
        DispatchQueue.global(qos: .background).async {
            do {
                let filePaths = try self.fileManager.contentsOfDirectory(atPath: self.imagesDirectoryURL.path)
                for filePath in filePaths {
                    try self.fileManager.removeItem(atPath: "\(self.imagesDirectoryURL.path)/\(filePath)")
                }
            } catch {
                print("Could not clear temp folder: \(error)")
            }
        }
    }
}
