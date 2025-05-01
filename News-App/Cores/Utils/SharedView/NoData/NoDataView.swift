//
//  NoDataView.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

import UIKit

class NoDataView: UIView {
    // MARK: - Outlets
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Variables
    var descriptionMessage = "" {
        didSet {
            descriptionLabel.text = descriptionMessage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        guard let view = loadFromNibWithOwner(nibName: "NoDataView") else {return}
        view.frame = self.bounds
        self.addSubview(view)
    }
}
