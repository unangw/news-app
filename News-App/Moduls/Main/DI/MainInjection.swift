//
//  MainInjection.swift
//  News-App
//
//  Created by BTS.id on 29/04/25.
//

import Foundation

class MainInjection: NSObject {
    static func provideService() -> MainServiceProtocol {
        return MainService()
    }
    
    static func provideMainViewModel() -> MainViewModelProtocol {
        return MainViewModel(service: provideService())
    }
}
