//
//  NewsItemCell.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit

class NewsItemCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Variables
    static let identifier = "NewsItemCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(article: ArticleItemModel?) {
        guard let article = article else { return }
        
        imageView.setImage(with: article.urlToImage)
        
        titleLabel.text = article.title ?? "-"
    }
}
