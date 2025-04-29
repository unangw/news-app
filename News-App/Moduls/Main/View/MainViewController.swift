//
//  MainViewController.swift
//  News-App
//
//  Created by BTS.id on 29/04/25.
//

import UIKit

class MainViewController: BaseViewController {
    // MARK: - Variables
    var didSendEventClosure: ((MainViewController.Event) -> Void)?
    var viewModel: MainViewModelProtocol?
    
    // MARK: - Life Cycle
    init(viewModel: MainViewModelProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("MainViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MainViewController {
    enum Event {
        case main
        case source
    }
}
