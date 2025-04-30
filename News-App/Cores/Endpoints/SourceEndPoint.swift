//
//  SourceEndPoint.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import Foundation
import Alamofire

enum SourceEndPoint {
    case getSource(request: SourceRequestModel)
}

extension SourceEndPoint: Endpoint {
    var path: String {
        switch self {
        case .getSource:
            return "/v2/top-headlines/sources"
        }
    }
    
    var header: [String: String] {
        return [:]
    }
    
    var body: [String: Any] {
        return [:]
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var queryItems: [String: Any] {
        switch self {
        case .getSource(let request):
            let httpBody: [String: Any?] = [
                "apiKey": Environment.apiKey,
                "category": request.category,
                "country": request.country,
                "language": request.language,
            ]
            return httpBody.compactMapValues { $0 }
        }
    }
    
    var authorization: Bool {
        return true
    }
    
    var timeoutInterval: Double? {
        return nil
    }
}
