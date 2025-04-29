//
//  Environment.swift
//  News-App
//
//  Created by BTS.id on 29/04/25.
//

import Foundation

public enum Environment {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let scheme = "SCHEME"
            static let host = "HOST"
            static let apiKey = "API_KEY"
            static let envName = "ENV_NAME"
        }
    }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    // MARK: - Plist values
    static let scheme: String = {
        guard let scheme = Environment.infoDictionary[Keys.Plist.scheme] as? String else {
            fatalError("Scheme not set in plist for this environment")
        }
        return scheme
    }()
    
    static let host: String = {
        guard let host = Environment.infoDictionary[Keys.Plist.host] as? String else {
            fatalError("Host not set in plist for this environment")
        }
        return host
    }()
    
    static let apiKey: String = {
        guard let apiKey = Environment.infoDictionary[Keys.Plist.apiKey] as? String else {
            fatalError("Api key not set in plist for this environment")
        }
        return apiKey
    }()
    
    static let envType: String = {
        guard let envType = Environment.infoDictionary[Keys.Plist.envName] as? String else {
            fatalError("Env Type App ID not set in plist for this environment")
        }
        return envType
    }()
    
    static let baseUrl: String = {
        return "\(scheme)://\(host)"
    }()
}
