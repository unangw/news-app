//
//  NewsDetailViewController.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

import UIKit

class NewsDetailsViewController: BaseViewController {
    var didSendEventClosure: ((NewsDetailsViewController.Event) -> Void)?
    var article: ArticleItemModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Setup UI
        setupUI()
    }
    
    private func setupUI() {
        // MARK: Setup Navigation
        setupNavigation()
    }
    
    private func setupNavigation() {
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(closeNewsDetailsScreen))
        setupNavigationBar(title: "Article Details", backAction: backGesture)
    }
    
    @objc private func closeNewsDetailsScreen() {
        didSendEventClosure?(.newsDetails)
    }
}

extension NewsDetailsViewController {
    enum Event {
        case newsDetails
    }
}
