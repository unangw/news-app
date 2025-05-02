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
            let dataTask = await AF.request( try endpoint.asURLRequest(), interceptor: nil).serializingDecodable(T.self).response
            
            if Environment.envType == "dev" {
                debugPrint(dataTask)
            }
            
            switch dataTask.result {
            case .success(let data):
                return .success(data)
            case .failure(let error):
                var httpError: HTTPError!
                
                if let urlError = error.underlyingError as? URLError,
                   urlError.code == .notConnectedToInternet {
                    httpError = .noInternet
                } else {
                    httpError = .unknown(code: dataTask.response?.statusCode)
                }
                
                showErrorViewController(error: httpError)
                
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

    func showErrorViewController(error: HTTPError) {
        DispatchQueue.main.async {
            let errorVC: ErrorViewController = .init(error: error)
            
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
