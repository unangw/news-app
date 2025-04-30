//
//  UIStackView+Ext.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        self.arrangedSubviews.forEach { view in
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
