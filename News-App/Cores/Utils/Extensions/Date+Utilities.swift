//
//  Date+Utilities.swift
//  News-App
//
//  Created by BTS.id on 01/05/25.
//

import Foundation

extension String {
    func toDisplayedDate() -> String {
        let string = self
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]
        
        let date = isoFormatter.date(from: string)!
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
            
        let formattedDate = formatter.string(from: date)
        
        return formattedDate
    }
}
