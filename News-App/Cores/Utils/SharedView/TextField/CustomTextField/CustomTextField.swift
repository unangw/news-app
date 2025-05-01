//
//  CustomTextField.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

//
//  CustomTextField.swift
//  AIM
//
//  Created by BTS.id on 12/12/24.
//

import UIKit
import Foundation

class CustomTextField: UIView {
    // MARK: - Outlets
    @IBOutlet weak var textField: PaddedTextField!
    
    // MARK: - Variables
    var placeholder: String = "Enter" {
        didSet {
            textField.placeholder = placeholder
        }
    }
    var readOnly: Bool = false
    var delegate: UITextFieldDelegate? {
        didSet {
            textField.delegate = delegate
        }
    }
    var keyboardType: UIKeyboardType? {
        didSet {
            guard let type = keyboardType else {return}
            
            textField.keyboardType = type
        }
    }
    var textContentType: UITextContentType? {
        didSet {
            guard let type = textContentType else {return}
            
            textField.textContentType = type
        }
    }
    var onChanged: ((Any) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        guard let view = loadFromNibWithOwner(nibName: "CustomTextField") else {return}
        view.frame = self.bounds
        self.addSubview(view)
        
        setupTextFieldStyle()
    }
    
    private func setupTextFieldStyle() {
        textField.delegate = self
        
        // MARK: - Setup Placeholder Style
        setupPlaceholderStyle()
    }
    
    private func setupPlaceholderStyle() {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: nil)
    }
    
    @IBAction func onChangedTextField(_ sender: Any) {
        self.onChanged?(sender)
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !readOnly
    }
}

extension CustomTextField {
    func loadFromNibWithOwner(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
