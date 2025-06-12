//
//  ReceiptHistoryViewModel.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import Foundation

final class ReceiptHistoryViewModel: ObservableObject {
    @Published var receipts: [String] = []
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        
        loadReceipts()
    }
    
    func loadReceipts() {
        Task { [weak self] in
            guard let self = self else {
                return
            }
            do {
                let result = try await self.dependencies.receiptHistoryRepository.getReceipts()
                await MainActor.run {
                    self.receipts = result
                }
            } catch {
                // Handle error
            }
        }
    }
}

extension ReceiptHistoryViewModel {
    struct Dependencies {
        let receiptHistoryRepository: ReceiptHistoryRepositoryProtocol
        
        static var defaultOption: Dependencies {
            .init(receiptHistoryRepository: ReceiptHistoryRepository())
        }
    }
}
