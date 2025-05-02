//
//  UITextField+Ext.swift
//  News-App
//
//  Created by BTS.id on 02/05/25.
//

import UIKit

extension UITextField {
    func setSuffix(_ image: UIImage, target: Any?, action: Selector?) {
        let iconView = UIImageView()
        let iconContainerView: UIView = UIView()
        let tapIconGesture = UITapGestureRecognizer(target: target, action: action)
        
        iconView.image = image.withRenderingMode(.alwaysTemplate)
        iconView.isUserInteractionEnabled = true
        iconView.addGestureRecognizer(tapIconGesture)
        iconContainerView.addSubview(iconView)
        
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Icon Container View constraints
            iconContainerView.heightAnchor.constraint(equalToConstant: 36),
            iconContainerView.widthAnchor.constraint(equalToConstant: 36),
            
            // Icon View constraints
            iconView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 16),
            iconView.widthAnchor.constraint(equalToConstant: 16)
        ])
        
        rightView = iconContainerView
        rightViewMode = .always
    }
}
