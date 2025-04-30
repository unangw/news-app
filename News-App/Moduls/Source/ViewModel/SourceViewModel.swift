//
//  SourceViewModel.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

protocol SourceViewModelProtocol {
    // MARK: - States
    
    // MARK: - Variables
    
    // MARK: - Functions
}

class SourceViewModel: SourceViewModelProtocol {
    let service: SourceServiceProtocol
    
    init(service: SourceServiceProtocol) {
        self.service = service
    }
}
