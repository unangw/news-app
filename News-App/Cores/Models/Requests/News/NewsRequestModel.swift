//
//  NewsRequestModel.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

struct NewsRequestModel: Equatable, Codable {
    let q: String?
    var sources: [String]?
    let pageSize: Int?
    let page: Int?
}
