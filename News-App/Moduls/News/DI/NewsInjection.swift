//
//  NewsInjection.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import Foundation

class NewsInjection: NSObject {
    static func provideService() -> NewsServiceProtocol {
        return NewsService()
    }
    
    static func provideNewsViewModel() -> NewsViewModelProtocol {
        return NewsViewModel(service: provideService())
    }
}
