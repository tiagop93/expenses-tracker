//
//  Receipt.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import Foundation

struct Receipt: Identifiable, Hashable {
    let id: UUID
    var name: String
    var date: Date
    var amount: Decimal
    var currency: String
    var image: Data?
}
