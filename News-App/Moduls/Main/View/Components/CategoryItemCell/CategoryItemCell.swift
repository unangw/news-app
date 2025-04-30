//
//  CategoryItemCell.swift
//  News-App
//
//  Created by BTS.id on 29/04/25.
//

import UIKit

class CategoryItemCell: UICollectionViewCell {
    // MARK: - Outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryImage: UIImageView!
    
    // MARK: - Variables
    static let identifier = "CategoryItemCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.borderColor = UIColor.black
    }
    
    func configure(category: String, icon: UIImage) {
        categoryLabel.text = category.capitalized
        
        categoryImage.image = icon
    }
    
    /// Don't remove this function if use CustomFlowLayout
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
