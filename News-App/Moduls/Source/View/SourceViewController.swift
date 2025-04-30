//
//  SourceViewController.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit

class SourceViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var didSendEventClosure: ((SourceViewController.Event) -> Void)?
    var viewModel: SourceViewModelProtocol?
    var category: String!
    
    // MARK: - Life Cycle
    init(viewModel: SourceViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("SourceViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Setup UI
        setupUI()
        
    }
    
    private func setupUI() {
        // MARK: - Setup Navigation
        setupNavigation()
        
        // MARK: - Setup Collection View
        setupCollectionView()
    }
    
    private func setupNavigation() {
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(closeSourceScreen))
        setupNavigationBar(title: "Source List", backAction: backGesture)
    }
    
    private func setupCollectionView() {
        
    }
    
    @objc private func closeSourceScreen() {
        didSendEventClosure?(.source)
    }
}

extension SourceViewController {
    enum Event {
        case source
        case news
    }
}
