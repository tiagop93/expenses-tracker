//
//  ReceiptHistoryRepositoryProtocol.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

protocol ReceiptHistoryRepositoryProtocol {
    func getReceipts() async throws -> [String]
    func save(receipt: Receipt) throws
}

final class ReceiptHistoryRepository: ReceiptHistoryRepositoryProtocol {
    private let persistence: PersistenceController
    private let factory = ReceiptModelFactory()

    init(persistence: PersistenceController = CoreDataController.shared) {
        self.persistence = persistence
    }
    
    func getReceipts() async throws -> [String] {
        ["Receipt 1", "Receipt 2", "Receipt 3"]
    }

    func save(receipt: Receipt) throws {
        let context = persistence.viewContext
        _ = factory.toEntity(receipt, in: context)
        try context.save()
    }
}
