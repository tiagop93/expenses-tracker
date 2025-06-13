//
//  ReceiptModelFactory.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import Foundation
import CoreData

struct ReceiptModelFactory {
    func toDomain(from entity: ReceiptEntity) -> Receipt? {
        guard let id = entity.id,
              let name = entity.name,
              let date = entity.date,
              let currency = entity.currency,
              let amount = entity.amount as? Decimal else {
            return nil
        }
        
        return Receipt(
            id: id,
            name: name,
            date: date,
            amount: amount,
            currency: currency,
            image: entity.imageData
        )
    }
    
    func toEntity(_ model: Receipt, in context: NSManagedObjectContext) -> ReceiptEntity {
        let entity = ReceiptEntity(context: context)
        entity.id = model.id
        entity.name = model.name
        entity.date = model.date
        entity.amount = model.amount as NSDecimalNumber
        entity.currency = model.currency
        entity.imageData = model.image
        entity.createdAt = Date()
        return entity
    }
}
