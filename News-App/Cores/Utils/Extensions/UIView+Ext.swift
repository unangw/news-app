//
//  UIView+Ext.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

import UIKit

extension UIView {
    func loadFromNibWithOwner(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
