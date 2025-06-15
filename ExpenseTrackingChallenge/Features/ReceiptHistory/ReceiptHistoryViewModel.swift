//
//  ReceiptHistoryViewModel.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import Foundation

protocol ReceiptHistoryViewModelProtocol: ObservableObject {
    var state: ReceiptHistoryViewModel.State { get }
    
    func loadReceipts() async
    func didPressCreateReceipt()
    func didPressReceipt(receipt: Receipt)
}

final class ReceiptHistoryViewModel: ReceiptHistoryViewModelProtocol {
    @Published var state: State = .idle
    
    private let dependencies: Dependencies
    private let coordinator: ReceiptHistoryCoordinatorProtocol
    
    init(dependencies: Dependencies, coordinator: ReceiptHistoryCoordinatorProtocol) {
        self.dependencies = dependencies
        self.coordinator = coordinator
    }
    
    @MainActor
    func loadReceipts() async {
        state = .loading
        do {
            let receipts = try await dependencies.receiptHistoryRepository.getReceipts()
            state = receipts.isEmpty ? .empty : .success(receipts)
        } catch {
            state = .failed(String(describing: error))
        }
    }
    
    func didPressCreateReceipt() {
        coordinator.goToCreateReceipt()
    }
    
    func didPressReceipt(receipt: Receipt) {
        coordinator.goToEditReceipt(receipt)
    }
    
    enum State: Equatable {
        case idle
        case loading
        case success([Receipt])
        case empty
        case failed(String)
    }
}

extension ReceiptHistoryViewModel {
    struct Dependencies {
        let receiptHistoryRepository: ReceiptRepositoryProtocol
        
        static var defaultOption: Dependencies {
            .init(receiptHistoryRepository: ReceiptRepository())
        }
        
        static var mock: Dependencies {
            let mockPersistence = MockCoreDataController()
              let repository = ReceiptRepository(persistence: mockPersistence)

              let context = mockPersistence.viewContext
              let factory = ReceiptModelFactory()

              let receipt1 = Receipt(
                  id: UUID(),
                  name: "Train Ticket",
                  date: Date(),
                  amount: 25.00,
                  currency: "EUR",
                  image: nil
              )

              let receipt2 = Receipt(
                  id: UUID(),
                  name: "Dinner",
                  date: Date().addingTimeInterval(-86400),
                  amount: 30.50,
                  currency: "USD",
                  image: nil
              )

              _ = factory.toEntity(receipt1, in: context)
              _ = factory.toEntity(receipt2, in: context)
              try? context.save()

              return .init(receiptHistoryRepository: repository)
        }
    }
}
