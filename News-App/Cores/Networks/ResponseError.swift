//
//  ResponseError.swift
//  News-App
//
//  Created by BTS.id on 29/04/25.
//

import Foundation

enum ResponseError: Error {
    case invalidURL
    case connection
    case pageNotFound
    case server(message: String)
    case decode(message: String)
    case unknown
    case cancelled
    case customMessage(message: String)
}

extension ResponseError {
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "An invalid URL."
        case .pageNotFound:
            return "Page Not Found!"
        case let .server(message: message):
            return message
        case .connection:
            return "Check your internet connection"
        case .decode(let message):
            return message
        case .unknown:
            return "An unknown error occured."
        case .cancelled:
            return "Cancel request"
        case .customMessage(let message):
            return message
        }
    }
}
