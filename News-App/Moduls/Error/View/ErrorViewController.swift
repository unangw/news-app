//
//  ErrorViewController.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

import UIKit

class ErrorViewController: BaseViewController {
    @IBAction func tryAgainPressed(_ sender: UIButton) {
        dismiss(animated: true) {
            RetryManager.shared.triggerRetry()
        }
    }
}
