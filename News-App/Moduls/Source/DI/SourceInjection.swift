//
//  SourceInjection.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import Foundation

class SourceInjection: NSObject {
    static func provideService() -> SourceServiceProtocol {
        return SourceService()
    }
    
    static func provideSourceViewModel() -> SourceViewModelProtocol {
        return SourceViewModel(service: provideService())
    }
}
