//
//  ReceiptRepositoryProtocol.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import CoreData

protocol ReceiptRepositoryProtocol {
    func getReceipts(page: Int, pageSize: Int) async throws -> [Receipt]
    func save(receipt: Receipt) async throws
    func delete(receipt: Receipt) async throws
}

final class ReceiptRepository: ReceiptRepositoryProtocol {
    private let persistence: PersistenceController
    private let factory = ReceiptModelFactory()
    
    init(persistence: PersistenceController = CoreDataController.shared) {
        self.persistence = persistence
    }
    
    func getReceipts(page: Int, pageSize: Int) async throws -> [Receipt] {
        let bgContext = persistence.backgroundContext
        return try await withCheckedThrowingContinuation { continuation in
            bgContext.perform {
                do {
                    let request: NSFetchRequest<ReceiptEntity> = ReceiptEntity.fetchRequest()
                    request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    request.fetchOffset = page * pageSize
                    request.fetchLimit = pageSize
                    
                    let entities = try bgContext.fetch(request)
                    let receipts = entities.compactMap { self.factory.toDomain(from: $0) }
                    continuation.resume(returning: receipts)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func save(receipt: Receipt) async throws {
        let bgContext = persistence.backgroundContext
        try await withCheckedThrowingContinuation { continuation in
            bgContext.perform {
                do {
                    let fetchRequest: NSFetchRequest<ReceiptEntity> = ReceiptEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", receipt.id as CVarArg)
                    let matches = try bgContext.fetch(fetchRequest)
                    
                    let entity: ReceiptEntity
                    if let existing = matches.first {
                        entity = existing
                    } else {
                        entity = ReceiptEntity(context: bgContext)
                        entity.id = receipt.id
                        entity.createdAt = Date()
                    }
                    
                    // Update fields
                    entity.name = receipt.name
                    entity.date = receipt.date
                    entity.amount = receipt.amount as NSDecimalNumber
                    entity.currency = receipt.currency
                    entity.imageData = receipt.image
                    
                    try bgContext.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func delete(receipt: Receipt) async throws {
        let bgContext = persistence.backgroundContext
        try await withCheckedThrowingContinuation { continuation in
            bgContext.perform {
                do {
                    let fetchRequest: NSFetchRequest<ReceiptEntity> = ReceiptEntity.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", receipt.id as CVarArg)
                    let entities = try bgContext.fetch(fetchRequest)
                    for entity in entities {
                        bgContext.delete(entity)
                    }
                    try bgContext.save()
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
