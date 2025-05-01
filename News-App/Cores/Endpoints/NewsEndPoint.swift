//
//  NewsEndPoint.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

import Foundation
import Alamofire

enum NewsEndPoint {
    case getNews(request: NewsRequestModel)
}

extension NewsEndPoint: Endpoint {
    var path: String {
        switch self {
        case .getNews:
            return "/v2/everything"
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
        case .getNews(let request):
            let httpBody: [String: Any?] = [
                "apiKey": Environment.apiKey,
                "q": request.q,
                "sources": request.sources?.joined(separator: ","),
                "page": request.page,
                "pageSize": request.pageSize,
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
