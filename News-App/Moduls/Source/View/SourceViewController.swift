//
//  SourceViewController.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import UIKit
import SkeletonView

class SourceViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var didSendEventClosure: ((SourceViewController.Event) -> Void)?
    var viewModel: SourceViewModelProtocol?
    var category: String!
    let refreshControl = UIRefreshControl()
    let customFlowLayout = CustomFlowLayout()
    var sourceIsLoading: Bool = false {
        didSet {
            reloadCollectionView()
        }
    }
    
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
    }
    
    private func setupNavigation() {
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(closeSourceScreen))
        setupNavigationBar(title: "Source List", backAction: backGesture)
    }
    
    private func setupCollectionView() {
        // MARK: - Setup CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // MARK: - Register Cell
        let nib = UINib(nibName: SourceItemCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: SourceItemCell.identifier)
        
        let shimmerNib = UINib(nibName: SourceShimmerCell.identifier, bundle: nil)
        collectionView.register(shimmerNib, forCellWithReuseIdentifier: SourceShimmerCell.identifier)
        
        // MARK: - Configure CollectionView
        customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        customFlowLayout.minimumLineSpacing = 16
        customFlowLayout.minimumInteritemSpacing = 16
        customFlowLayout.sectionInset.top = 24
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
    
    private func setupNoData() {
        let emptyLabel = UILabel()
        
        emptyLabel.text = "Source is empty!"
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
        self.collectionView.reloadData()
        
        if !sourceIsLoading && (viewModel?.sources.isEmpty ?? true) {
            setupNoData()
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    private func observeEvent() {
        // MARK: - Observe Get Source Event
        getSourceEvent()
    }
    
    @objc private func refreshData() {
        fetchData()
    }
    
    private func fetchData() {
        // MARK: - Get Source
        getSource()
    }
    
    private func getSource() {
        let request = SourceRequestModel(category: category, language: nil, country: nil)
        
        viewModel?.getSource(request: request)
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

extension SourceViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // Part of UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceIsLoading ? 8 : viewModel?.sources.count ?? 0
    }
    
    // Part of UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if sourceIsLoading {
            cell =  collectionView.dequeueReusableCell(withReuseIdentifier: SourceShimmerCell.identifier, for: indexPath)
            
            cell.showAnimatedSkeleton()
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: SourceItemCell.identifier, for: indexPath)
            
            if !(viewModel?.sources.isEmpty ?? true) {
                // Configure cell
                (cell as! SourceItemCell).configure(source: viewModel?.sources[indexPath.item])
            }
        }
        
        return cell
    }
    
    // Part of UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - State Event Extensions
extension SourceViewController {
    private func getSourceEvent() {
        viewModel?.getSourceState = { [weak self] state in
            guard let self else { return }
            
            switch state {
            case .loading:
                DispatchQueue.main.async {
                    self.sourceIsLoading = true
                }
            case .loaded:
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    
                    self.sourceIsLoading = false
                }
            case .error(_):
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    
                    self.sourceIsLoading = false
                }
            }
        }
    }
}
