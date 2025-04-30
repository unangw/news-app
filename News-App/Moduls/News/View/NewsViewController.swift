//
//  NewsViewController.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit
import SkeletonView

class NewsViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var didSendEventClosure: ((NewsViewController.Event) -> Void)?
    var viewModel: NewsViewModelProtocol?
    var source: SourceItemModel!
    
    // MARK: - Life Cycle
    init(viewModel: NewsViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("NewsViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Observe Event
        observeEvent()
        
        // MARK: - Setup UI
        setupUI()
        
        // MARK: - Fetch Data
        fetchData()
    }
    
    private func setupUI() {
        // MARK: - Setup Navigation
        setupNavigation()
    }
    
    private func setupNavigation() {
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(closeNewsScreen))
        setupNavigationBar(title: "News", backAction: backGesture)
    }
    
    private func observeEvent() {
        
    }
    
    @objc private func refreshData() {
        fetchData()
    }
    
    private func fetchData() {
        
    }
    
    @objc private func closeNewsScreen() {
        didSendEventClosure?(.news)
    }
}

extension NewsViewController {
    enum Event {
        case news
        case newsDetail
    }
}
