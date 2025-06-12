//
//  ReceiptHistoryRepositoryProtocol.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

protocol ReceiptHistoryRepositoryProtocol {
    func getReceipts() async throws -> [String]
}

final class ReceiptHistoryRepository: ReceiptHistoryRepositoryProtocol {
    func getReceipts() async throws -> [String] {
        ["Receipt 1", "Receipt 2", "Receipt 3"]
    }
}
