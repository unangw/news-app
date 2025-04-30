//
//  GeneralChipView.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit

class GeneralChipView: UIView {
    // MARK: - Variables
    private let chipLabel = UILabel()
    var label: String? {
        didSet {
            if label != nil {
                setupNotNilLabel()
                
                chipLabel.text = label
            } else {
                setupNilLabel()
            }
        }
    }
    private var topConstraint: NSLayoutConstraint!
    private var bottomConstraint: NSLayoutConstraint!
    private var leadingConstraint: NSLayoutConstraint!
    private var trailingConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .lightGray
        self.layer.borderColor = UIColor.black.cgColor
        
        self.layer.borderWidth = 0.5
        
        chipLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        chipLabel.textColor = .black
        chipLabel.textAlignment = .center
        chipLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(chipLabel)
        
        // Add constraint
        topConstraint = chipLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4)
        bottomConstraint = chipLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        leadingConstraint = chipLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        trailingConstraint = chipLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12)
        
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leadingConstraint, trailingConstraint])
    }
    
    private func setupNotNilLabel() {
        self.backgroundColor = .lightGray
        self.layer.borderColor = UIColor.black.cgColor
        
        self.layer.borderWidth = 0.5
        
        chipLabel.textColor = .black
        chipLabel.textAlignment = .center
        
        // Change constraints
        topConstraint.constant = 4
        leadingConstraint.constant = 12
    }
    
    private func setupNilLabel() {
        self.backgroundColor = nil
        self.layer.borderColor = nil
        
        self.layer.borderWidth = 0
        
        chipLabel.textColor = .black
        chipLabel.textAlignment = .left
        
        chipLabel.text = "-"
        
        // Change constraints
        topConstraint.constant = 0
        leadingConstraint.constant = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Setup corner radius
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
}

