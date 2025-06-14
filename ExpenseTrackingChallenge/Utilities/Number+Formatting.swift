//
//  Currency+Formatting.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 14/06/2025.
//

import Foundation

extension NumberFormatter {
    static func currencyFormatter(code: String) -> NumberFormatter {
      let f = NumberFormatter()
      f.numberStyle = .currency
      f.currencyCode = code
      return f
    }
}

extension Decimal {
  func formattedCurrency(code: String) -> String {
    let number = NSDecimalNumber(decimal: self)
    return NumberFormatter
      .currencyFormatter(code: code)
      .string(from: number)
      ?? number.stringValue
  }
}
