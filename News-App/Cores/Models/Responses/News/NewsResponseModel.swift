//
//  NewsResponseModel.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

struct NewsResponseModel: Equatable, Codable {
    let status: String?
    let totalResults: Int?
    let articles: [ArticleItemModel]?
}
