//
//  PaddedTextField.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

import UIKit

class PaddedTextField: UITextField {
    // MARK: - Variables
    var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    /// Set padding for text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    /// Set padding when text is editing
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    /// Set padding for placeholder
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
