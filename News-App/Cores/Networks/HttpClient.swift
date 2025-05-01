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
            let dataTask = await AF.request( try endpoint.asURLRequest(), interceptor: MyRequestInterceptor()).serializingDecodable(T.self).response
            
            if Environment.envType == "dev" {
                debugPrint(dataTask)
            }
            
            switch dataTask.result {
            case .success(let data):
                return .success(data)
            case .failure(let error):
                // Check if there is no internet connection
                if let urlError = error.underlyingError as? URLError,
                   urlError.code == .notConnectedToInternet {
                    // Showing error page
                    showErrorViewController()
                    
                    // Save retry action & suspend it temporarily until retry is performed
                    return try await withCheckedThrowingContinuation { continuation in
                        RetryManager.shared.save(
                            retryAction: {
                                try await self.sendRequest(endpoint: endpoint, responseModel: responseModel)
                            },
                            continuation: { (result: Result<T, ResponseError>) in
                                continuation.resume(returning: result)
                            }
                        )
                    }
                }

                
                // Handle other errors
                switch error {
                case .explicitlyCancelled:
                    return .failure(.cancelled)
                case .sessionTaskFailed(let error):
                    return .failure(.customMessage(message: error.localizedDescription))
                default:
                    return .failure(.customMessage(message: error.localizedDescription))
                }
            }
        } catch {
            return .failure(.customMessage(message: error.localizedDescription))
        }
    }
    
    func getTopViewController() -> UIViewController? {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = scene.windows.first(where: { $0.isKeyWindow }) {
                var topController = window.rootViewController
                while let presentedController = topController?.presentedViewController {
                    topController = presentedController
                }
                return topController
            }
        }
        return nil
    }

    func showErrorViewController() {
        DispatchQueue.main.async {
            let errorVC: ErrorViewController = .init()
            
            let navigationController = UINavigationController(rootViewController: errorVC)
            navigationController.modalPresentationStyle = .overFullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            
            if let topViewController = getTopViewController() {
                if topViewController.presentedViewController == nil {
                    topViewController.present(navigationController, animated: true)
                } else {
                    topViewController.presentedViewController?.present(navigationController, animated: true)
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
