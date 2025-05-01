//
//  Category.swift
//  News-App
//
//  Created by BTS.id on 29/04/25.
//

import UIKit

class Category {
    static var list: [String] = [
        "general",
        "business",
        "entertainment",
        "health",
        "science",
        "sport",
        "techology"
    ]
    
    static var images: [UIImage] = [
        .imgGeneral,
        .imgBusiness,
        .imgEntertainment,
        .imgHealth,
        .imgScience,
        .imgSport,
        .imgTechnology
    ]
    
    static var colors: [String] = [
        "#666666",
        "#4A90E2",
        "#D64541",
        "#4EC3B5",
        "#F5A623",
        "#9B59B6",
        "#6D9E3F"
    ]
}
