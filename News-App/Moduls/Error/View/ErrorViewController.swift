//
//  ErrorViewController.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

import UIKit

class ErrorViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var errorCodeLabel: UILabel!
    
    // MARK: - Variables
    var error: HTTPError!
    
    init(error: HTTPError) {
        super.init(nibName: nil, bundle: nil)
        
        self.error = error
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Setup UI
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ErrorViewController deinit")
    }
    
    private func setupUI() {
        switch error {
        case .noInternet:
            titleLabel.text = "No Internet Connection"
            errorCodeLabel.isHidden = true
        case .unknown(let errorCode):
            titleLabel.text = "Oops! Something went wrong"
            
            if let errorCode = errorCode {
                errorCodeLabel.text = "Error code: \(errorCode)"
            } else {
                errorCodeLabel.isHidden = true
            }
        case .none:
            break
        }
    }
    
    @IBAction func tryAgainPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            RetryManager.shared.triggerRetry()
        }
    }
}
