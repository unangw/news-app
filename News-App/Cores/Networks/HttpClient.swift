//
//  HttpClient.swift
//  News-App
//
//  Created by BTS.id on 29/04/25.
//

import Foundation
import Alamofire

protocol HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> Result<T, ResponseError>
}

extension HTTPClient {
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async throws -> Result<T, ResponseError> {
        
        do {
            let dataTask = await AF.request(try endpoint.asURLRequest(), interceptor: MyRequestInterceptor()).serializingDecodable(T.self).response
            
            if Environment.envType == "dev" {
                debugPrint(dataTask)
            }
            
            switch dataTask.result {
            case .success(let data):
                return .success(data)
            case .failure(let error):
                switch error {
                case .explicitlyCancelled:
                    return .failure(.cancelled)
                case .sessionTaskFailed(let error):
                    return .failure(.customMessage(message: error.localizedDescription))
                default:
                    return .failure(.customMessage(message: error.localizedDescription))
                }
            }
        }
    }
}

class MyRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        
        adaptedRequest.headers.add(name: "apiKey", value: Environment.apiKey)
        
        completion(.success(adaptedRequest))
    }
}
