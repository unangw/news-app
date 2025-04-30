//
//  SourceResponseModel.swift
//  News-App
//
//  Created by BTS.id on 30/04/25.
//

struct SourceResponseModel: Equatable, Codable {
    let status: String?
    let sources: [SourceItemModel]?
}
