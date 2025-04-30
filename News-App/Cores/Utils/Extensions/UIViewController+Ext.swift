//
//  UIViewController+Ext.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit

extension UIViewController {
    // MARK: - Custom navigator bar
    func setupNavigationBar(title: String = "", backAction: UITapGestureRecognizer? = nil, rightCustomView: [UIView] = []) {
        
        /// Custom back button
        lazy var backButton: UIView = {
            let customView = UIView()
            customView.translatesAutoresizingMaskIntoConstraints = false
            customView.backgroundColor = .clear
            
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = .icArrowLeft
            
            customView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: customView.centerYAnchor),
                imageView.heightAnchor.constraint(equalToConstant: 24),
                imageView.widthAnchor.constraint(equalToConstant: 24),
            ])
            
            let tapGesture = (backAction != nil) ? backAction : UITapGestureRecognizer(target: self, action: #selector(backPressed(_:)))
            customView.addGestureRecognizer(tapGesture!)
            
            customView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            customView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            
            return customView
        }()
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBarApperance()
        
        if !title.isEmpty {
            let titleView = UILabel()
            titleView.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            
            titleView.text = title
            titleView.textAlignment = .left
            
            titleView.translatesAutoresizingMaskIntoConstraints = false
            backButton.translatesAutoresizingMaskIntoConstraints = false
            
            let stackView = UIStackView(arrangedSubviews: [backButton, titleView])
            stackView.axis = .horizontal
            stackView.spacing = 16
            stackView.alignment = .center
            
            let leftButtonItem = UIBarButtonItem(customView: stackView)
            navigationItem.leftBarButtonItem = leftButtonItem
            
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        }
        
        // Set up UIBarButtonItems using customView(UIView)
        navigationItem.rightBarButtonItems = rightCustomView.map { item in
            UIBarButtonItem(customView: item)
        }
    }
}

extension UIViewController {
    @objc func backPressed(_ sender: UIBarButtonItem) {
        guard presentingViewController != nil else {
            navigationController?.popViewController(animated: true)
            return
        }
        dismiss(animated: false)
    }
}
