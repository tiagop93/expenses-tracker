//
//  ReceiptHistoryViewModel+Mocks.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 16/06/2025.
//

import Foundation

extension ReceiptHistoryViewModel.Dependencies {
    
    static var seeded: ReceiptHistoryViewModel.Dependencies {
        let mockPersistence = MockCoreDataController()
        let repository = ReceiptRepository(persistence: mockPersistence)
        let context = mockPersistence.viewContext
        let factory = ReceiptModelFactory()
        
        for i in 1...30 {
            let receipt = Receipt(
                id: UUID(),
                name: "Train Ticket \(i)",
                date: Date(),
                amount: 25.00,
                currency: "EUR",
                image: nil
            )
            _ = factory.toEntity(receipt, in: context)
        }
        
        try? context.save()
        
        return .init(receiptHistoryRepository: repository)
    }
}
