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

    func fillTableCell(article: ArticleModel, images: [Image]) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        dateLabel.text = DateFormatterManager.shared.getStringFromDate(date: article.date)
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
}
