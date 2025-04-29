//
//  MainViewModel.swift
//  News-App
//
//  Created by BTS.id on 29/04/25.
//

import Foundation

protocol MainViewModelProtocol {
    // MARK: - States
    
    // MARK: - Variables
    
    // MARK: - Functions
}

class MainViewModel: MainViewModelProtocol {
    let service: MainServiceProtocol
    
    init(service: MainServiceProtocol) {
        self.service = service
    }
}
