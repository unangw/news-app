//
//  SourceShimmerCell.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit

class SourceShimmerCell: UICollectionViewCell {
    // MARK: - Variables
    static let identifier = "SourceShimmerCell"
    
    /// Don't remove this function if use CustomFlowLayout
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}
