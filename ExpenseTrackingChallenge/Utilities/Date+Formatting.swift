//
//  Date+Formatting.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 14/06/2025.
//

import Foundation

extension Date {
    
    static let mediumDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f
    }()
    
    var formattedMedium: String {
        Self.mediumDateFormatter.string(from: self)
    }
}
