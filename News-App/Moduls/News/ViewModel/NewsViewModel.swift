//
//  NewsViewModel.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

protocol NewsViewModelProtocol {
    // MARK: - States
    
    // MARK: - Variables
    
    // MARK: - Functions
}

class NewsViewModel: NewsViewModelProtocol {
    let service: NewsServiceProtocol
    
    init(service: NewsServiceProtocol) {
        self.service = service
    }
}
