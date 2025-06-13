//
//  ReceiptHistoryRepositoryProtocol.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import CoreData

protocol ReceiptHistoryRepositoryProtocol {
    func getReceipts() async throws -> [Receipt]
    func save(receipt: Receipt) throws
}

final class ReceiptHistoryRepository: ReceiptHistoryRepositoryProtocol {
    private let persistence: PersistenceController
    private let factory = ReceiptModelFactory()

    init(persistence: PersistenceController = CoreDataController.shared) {
        self.persistence = persistence
    }
    
    func getReceipts() async throws -> [Receipt] {
        let context = persistence.viewContext
        let request: NSFetchRequest<ReceiptEntity> = ReceiptEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        let entities = try context.fetch(request)
        return entities.compactMap { factory.toDomain(from: $0) }
    }

    func save(receipt: Receipt) throws {
        let context = persistence.viewContext
        _ = factory.toEntity(receipt, in: context)
        try context.save()
    }
}
