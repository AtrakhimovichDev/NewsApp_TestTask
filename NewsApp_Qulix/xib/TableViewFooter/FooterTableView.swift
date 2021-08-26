//
//  FooterTableView.swift
//  NewsApp_Qulix
//
//  Created by Andrei Atrakhimovich on 26.08.21.
//

import UIKit

class FooterTableView: UITableViewHeaderFooterView {

    let activityIndicator = UIActivityIndicatorView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
