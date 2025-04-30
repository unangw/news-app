//
//  ArticleItemModel.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

struct ArticleItemModel: Equatable, Codable {
    let source: SourceItemModel?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
