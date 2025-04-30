//
//  SourceService.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

protocol SourceServiceProtocol {
    func getSource(request: SourceRequestModel) async throws -> Result<SourceResponseModel, ResponseError>
}

class SourceService: SourceServiceProtocol, HTTPClient {
    func getSource(request: SourceRequestModel) async throws -> Result<SourceResponseModel, ResponseError> {
        return try await sendRequest(endpoint: SourceEndPoint.getSource(request: request), responseModel: SourceResponseModel.self)
    }
    
    
}
