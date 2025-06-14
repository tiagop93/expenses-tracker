//
//  ReceiptRepositoryProtocol.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import CoreData

protocol ReceiptRepositoryProtocol {
    func getReceipts() async throws -> [Receipt]
    func save(receipt: Receipt) throws
    func delete(receipt: Receipt) throws
}

final class ReceiptRepository: ReceiptRepositoryProtocol {
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

        let request: NSFetchRequest<ReceiptEntity> = ReceiptEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", receipt.id as CVarArg)
        let matches = try context.fetch(request)

        let entity: ReceiptEntity
        if let existing = matches.first {
            entity = existing
        } else {
            entity = ReceiptEntity(context: context)
            entity.id = receipt.id
        }

        entity.name       = receipt.name
        entity.date       = receipt.date
        entity.amount     = receipt.amount as NSDecimalNumber
        entity.currency   = receipt.currency
        entity.imageData  = receipt.image
        entity.createdAt  = entity.createdAt ?? Date()

        try context.save()
    }

    
    func delete(receipt: Receipt) throws {
        let context = persistence.viewContext
        let request: NSFetchRequest<ReceiptEntity> = ReceiptEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", receipt.id as CVarArg)

        let entities = try context.fetch(request)
        for entity in entities {
            context.delete(entity)
        }

        try context.save()
    }
}
