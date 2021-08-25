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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillTableCell(article: ArticleJSON, images: [Image]) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        dateLabel.text = getFormattedDate(dateString: article.publishedAt)
        let imageURLString = article.urlToImage
        let imageArray = images.filter({ $0.imageURL == imageURLString })
        if !imageArray.isEmpty {
            if let img = imageArray.first {
                newsImageView.image = FilesManager.shared.getImage(image: img)
            }
        } else {
            newsImageView.image = UIImage(named: "default-news-image")
        }
    }

    private func getFormattedDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let dateStr = dateFormatter.string(from: date)
            return dateStr
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateStr = dateFormatter.string(from: Date())
            return dateStr
        }
    }
}
