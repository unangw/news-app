//
//  NewsService.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

protocol NewsServiceProtocol {
    func getNews(request: NewsRequestModel) async throws -> Result<NewsResponseModel, ResponseError>
}

class NewsService: NewsServiceProtocol, HTTPClient {
    func getNews(request: NewsRequestModel) async throws -> Result<NewsResponseModel, ResponseError> {
        return try await sendRequest(endpoint: NewsEndPoint.getNews(request: request), responseModel: NewsResponseModel.self)
    }
}
