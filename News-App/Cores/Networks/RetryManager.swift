//
//  RetryManager.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

final class RetryManager {
    static let shared = RetryManager()
    
    // Save retryQueue to save the exact result
    private var retryQueue: [(retryAction: () async throws -> Any, continuation: (Any) -> Void)] = []
    
    private init() {}
    
    // Function to save failed retry actions
    func save<T>(
        retryAction: @escaping () async throws -> Result<T, ResponseError>,
        continuation: @escaping (Result<T, ResponseError>) -> Void
    ) {
        let action: () async throws -> Any = {
            let result: Result<T, ResponseError> = try await retryAction()
            return result // Return results with the correct type
        }
        
        let actionContinuation: (Any) -> Void = { result in
            if let typedResult = result as? Result<T, ResponseError> {
                continuation(typedResult) // Return results with the appropriate type
            } else {
                continuation(.failure(.unknown)) // If it doesn't match, return failure
            }
        }
        
        retryQueue.append((retryAction: action, continuation: actionContinuation))
    }
    
    // Function to try to retry
    func triggerRetry() {
        Task {
            while !retryQueue.isEmpty {
                let retryItem = retryQueue.removeFirst()
                
                do {
                    let result = try await retryItem.retryAction()
                    retryItem.continuation(result)
                    
                    // If the result is successful, proceed to the next item.
                    if let typedResult = result as? Result<Any, ResponseError> {
                        switch typedResult {
                        case .success:
                            break // If the retry is successful, proceed to the next item.
                        case .failure:
                            retryQueue.append(retryItem) // Save items again for next retry
                        }
                    }
                } catch {
                    // If there is an error, save the item in the queue to try again.
                    retryQueue.append(retryItem)
                }
            }
        }
    }
    
    // Function to clear queue if necessary
    private func clear() {
        retryQueue.removeAll()
    }
}

