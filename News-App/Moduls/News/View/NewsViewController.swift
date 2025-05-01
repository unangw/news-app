//
//  NewsViewController.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit
import SkeletonView
import CHTCollectionViewWaterfallLayout

class NewsViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: CustomTextField!
    
    // MARK: - Variables
    var didSendEventClosure: ((NewsViewController.Event) -> Void)?
    var viewModel: NewsViewModelProtocol?
    var source: SourceItemModel!
    var customFlowLayout = CHTCollectionViewWaterfallLayout()
    let refreshControl = UIRefreshControl()
    var page = 1
    var searchTimer: Timer?
    var isLoadingNextPage: Bool = false
    var newsIsLoading = true
    private lazy var sizingCell: NewsItemCell = {
        guard let cell = Bundle.main.loadNibNamed(NewsItemCell.identifier, owner: nil)?.first as? NewsItemCell else {
            fatalError("Failed to load NewsItemCell.xib")
        }
        return cell
    }()
    
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
        
        // MARK: - Setup Collection View
        setupCollectionView()
        
        // MARK: - Setup Search Text Field
        setupSearchTextField()
    }
    
    private func setupNavigation() {
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(closeNewsScreen))
        setupNavigationBar(title: "News", backAction: backGesture)
    }
    
    private func setupCollectionView() {
        // MARK: - Setup CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // MARK: - Register Cell
        let nib = UINib(nibName: NewsItemCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: NewsItemCell.identifier)
        
        // MARK: - Configure CollectionView
        customFlowLayout.minimumInteritemSpacing = 16
        customFlowLayout.minimumColumnSpacing = 16
        customFlowLayout.sectionInset.left = 20
        customFlowLayout.sectionInset.right = 20
        customFlowLayout.sectionInset.bottom = 20
        collectionView.collectionViewLayout = customFlowLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.alwaysBounceVertical = true
        
        // MARK: - Add refresh control
        collectionView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func setupSearchTextField() {
        // MARK: - Setup Search TextField
        searchTextField.placeholder = "Search news here..."
        
        searchTextField.onChanged = {target in
            self.onChangerSearchTextField(target: target)
        }
    }
    
    private func setupNoData() {
        let emptyLabel = UILabel()
        
        emptyLabel.text = "News is empty!"
        emptyLabel.textAlignment = .center
        
        collectionView.backgroundView = emptyLabel
        
        // Set Constraints to center backgroundView
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
        ])
    }
    
    private func reloadCollectionView() {
        collectionView.reloadData()
        
        if !newsIsLoading && (viewModel?.articles.isEmpty ?? true) {
            setupNoData()
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    private func observeEvent() {
        // MARK: - Observe Get News Item
        getNewsEvent()
    }
    
    @objc private func refreshData() {
        fetchData()
    }
    
    private func fetchData() {
        // MARK: - Get News
        getNews()
    }
    
    private func getNews(page: Int = 1) {
        self.page = page
        
        var request = NewsRequestModel(
            q: searchTextField.textField.text,
            sources: nil,
            pageSize: 10,
            page: page
        )
        
        if let sourceId = source.id {
            request.sources = [sourceId]
        }
        
        viewModel?.getNews(request: request)
    }
    
    private func onChangerSearchTextField(target: Any) {
        searchTimer?.invalidate() // Cancel previous timer
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.getNews(page: 1)
        }
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

extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout {
    // Part of UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.articles.count ?? 0
    }
    
    // Part of UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsItemCell.identifier, for: indexPath)
        
        if !(viewModel?.articles.isEmpty ?? true) {
            // Configure cell
            (cell as! NewsItemCell).configure(article: viewModel?.articles[indexPath.item])
        }
        
        return cell
    }
    
    // Part of UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dataCount = viewModel?.articles.count ?? 0
        let countDataForDisplay = dataCount - indexPath.item
        
        if !(viewModel?.isMaxPage ?? false) && !newsIsLoading && !isLoadingNextPage && countDataForDisplay <= 1 {
            
            getNews(page: page+1)
        }
    }
    
    // Part of CHTCollectionViewDelegateWaterfallLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentWidth = (collectionView.bounds.width - (20 * 2 + 16)) / 2
        
        sizingCell.frame.size.width = contentWidth
        
        let item = viewModel?.articles[indexPath.item]
        sizingCell.configure(article: item)
        
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size = sizingCell.contentView.systemLayoutSizeFitting(
            CGSize(width: contentWidth, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: UILayoutPriority.required,
            verticalFittingPriority: UILayoutPriority.fittingSizeLevel
        )
        
        return CGSize(width: contentWidth, height: size.height)
    }
    
    // Part of CHTCollectionViewDelegateWaterfallLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountFor section: Int) -> Int {
        return 2
    }
}

// MARK: - Request State
extension NewsViewController {
    private func getNewsEvent() {
        viewModel?.getNewsState = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .loading:
                DispatchQueue.main.async {
                    if self.page == 1 { self.newsIsLoading = true }
                    
                    self.isLoadingNextPage = true
                    
                    self.reloadCollectionView()
                }
                break
            case .loaded:
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    
                    if self.page == 1 { self.newsIsLoading = false }
                    
                    self.isLoadingNextPage = false
                    
                    self.reloadCollectionView()
                }
                break
            case .error(let failure):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    
                    if self.page == 1 { self.newsIsLoading = false }
                    
                    self.isLoadingNextPage = false
                    
                    self.reloadCollectionView()
                    
                    self.showToast(with: failure.localizedDescription)
                }
                break
            }
        }
    }
}

