//
//  NewsTableViewCell.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 23.08.21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var showMoreLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 5
        cellView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        titleLabel.text = ""
        descriptionLabel.text = ""
        dateLabel.text = ""
        newsImageView.image = FilesManager.shared.getDefaultNewsImage()
    }

    func setupCell(article: ArticleModel) {
        showShowMoreLabel(description: article.description)
    }

    func fillTableCell(article: ArticleModel, news: NewsModel) {
        startActivityIndicator()
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        dateLabel.text = DateFormatterManager.shared.getStringFromDate(date: article.date)
        fillImage(url: article.urlToImage, news: news)
    }

    private func fillImage(url: String?, news: NewsModel) {
        if let imageURLString = url {
            let imageArray = news.images.filter({ $0.imageURL == imageURLString })
            if !imageArray.isEmpty {
                getImageFromFolder(image: imageArray.first)
            } else {
                getImageFromURL(url: imageURLString, news: news)
            }
        } else {
            stopActivityIndicator()
        }
    }

    private func getImageFromFolder(image: Image?) {
        if let image = image {
            newsImageView.image = FilesManager.shared.getImage(image: image)
        } else {
            newsImageView.image = FilesManager.shared.getDefaultNewsImage()
        }
        stopActivityIndicator()
    }

    private func getImageFromURL(url: String?, news: NewsModel) {
        NetworkRequestManager.downloadImage(urlString: url) { (uiImage, image) in
            self.stopActivityIndicator()
            if let uiImage = uiImage,
               let image = image {
                DispatchQueue.main.async {
                    self.newsImageView.image = uiImage
                }
                news.images.append(image)
            }
        }
    }

    private func startActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
    }

    private func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }

    private func showShowMoreLabel(description: String?) {
        if let description = description {
            let size = description.size(withAttributes: [.font: UIFont.systemFont(ofSize: 15.0)])
            let width = descriptionLabel.frame.width
            if size.width / width > 3 {
                showMoreLabel.isHidden = false
            } else {
                showMoreLabel.isHidden = true
            }
        } else {
            showMoreLabel.isHidden = true
        }
    }
}
