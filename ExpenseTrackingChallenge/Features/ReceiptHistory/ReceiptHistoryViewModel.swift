//
//  ReceiptHistoryViewModel.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import Foundation

protocol ReceiptHistoryViewModelProtocol: ObservableObject {
    var state: ReceiptHistoryViewModel.State { get }
    
    func loadReceipts()
    func didPressCaptureReceipt()
    func didPressReceiptDetails(id: UUID)
}

final class ReceiptHistoryViewModel: ReceiptHistoryViewModelProtocol {
    @Published var state: State = .idle
    
    private let dependencies: Dependencies
    private let coordinator: ReceiptHistoryCoordinatorProtocol
    
    init(dependencies: Dependencies, coordinator: ReceiptHistoryCoordinatorProtocol) {
        self.dependencies = dependencies
        self.coordinator = coordinator
    }
    
    func loadReceipts() {
        state = .loading
        
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.dependencies.receiptHistoryRepository.getReceipts()
                await MainActor.run {
                    if result.isEmpty {
                        self.state = .empty
                    } else {
                        self.state = .success(result)
                    }
                }
            } catch {
                await MainActor.run {
                    self.state = .failed("Failed to load receipts.")
                }
            }
        }
    }
    
    func didPressCaptureReceipt() {
        coordinator.goToCaptureReceipt()
    }
    
    func didPressReceiptDetails(id: UUID) {
        coordinator.goToReceiptDetails(id: id)
    }
    
    enum State {
        case idle
        case loading
        case success([Receipt])
        case empty
        case failed(String)
    }
}

extension ReceiptHistoryViewModel {
    struct Dependencies {
        let receiptHistoryRepository: ReceiptHistoryRepositoryProtocol
        
        static var defaultOption: Dependencies {
            .init(receiptHistoryRepository: ReceiptHistoryRepository())
        }
        
        static var mock: Dependencies {
            let mockPersistence = MockCoreDataController()
              let repository = ReceiptHistoryRepository(persistence: mockPersistence)

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
