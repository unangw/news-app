//
//  NewsDetailViewController.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

import UIKit
import WebKit

class NewsDetailsViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var articleWebView: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Variables
    var didSendEventClosure: ((NewsDetailsViewController.Event) -> Void)?
    var article: ArticleItemModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Setup UI
        setupUI()
    }
    
    private func setupUI() {
        // MARK: - Setup Navigation
        setupNavigation()
        
        // MARK: - Setup WebView
        setupWebView()
    }
    
    private func setupWebView() {
        articleWebView.navigationDelegate = self
        
        guard let urlString = article.url, let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        articleWebView.load(request)
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

extension NewsDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
}
