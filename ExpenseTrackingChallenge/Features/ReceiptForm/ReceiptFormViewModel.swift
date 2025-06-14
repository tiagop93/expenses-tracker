//
//  ReceiptFormViewModel.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import Foundation

protocol ReceiptFormViewModelProtocol: ObservableObject {
    var mode: ReceiptFormViewModel.Mode { get }
    
    var name: String { get set }
    var date: Date { get set }
    var amount: Decimal { get set }
    var currency: String { get set }
    var image: Data? { get set }

    var isSaving: Bool { get }
    var errorMessage: String? { get }

    func save() async
    func delete() async
    func cancel()
}

final class ReceiptFormViewModel: ReceiptFormViewModelProtocol {
    enum Mode: Hashable {
      case create
      case edit(existing: Receipt)
    }
    
    // MARK: - Form Fields
    @Published var name: String
    @Published var date: Date
    @Published var amount: Decimal
    @Published var currency: String
    @Published var image: Data?

    // MARK: - UI State
    @Published private(set) var isSaving: Bool = false
    @Published private(set) var errorMessage: String?
    
    
    // MARK: - Dependencies
    let mode: Mode
    private let dependencies: Dependencies
    private let coordinator: ReceiptFormCoordinatorProtocol
    
    init(
        mode: Mode,
        dependencies: Dependencies,
        coordinator: ReceiptFormCoordinatorProtocol
    ) {
        self.mode = mode
        self.dependencies = dependencies
        self.coordinator = coordinator

        switch mode {
        case .create:
            self.name = ""
            self.date = Date()
            self.amount = .zero
            self.currency = Locale.current.currency?.identifier ?? "EUR"
            self.image = nil
        case .edit(let existing):
            self.name = existing.name
            self.date = existing.date
            self.amount = existing.amount
            self.currency = existing.currency
            self.image = existing.image
        }
    }
    
    func save() async {
        isSaving = true
        errorMessage = nil

        do {
            // Determine identifier
            let id: UUID = {
                switch mode {
                case .create:
                    return UUID()
                case .edit(let existing):
                    return existing.id
                }
            }()

            // Build domain model
            let receipt = Receipt(
                id: id,
                name: name,
                date: date,
                amount: amount,
                currency: currency,
                image: image
            )

            // Persist changes
            try dependencies.receiptRepository.save(receipt: receipt)

            // Notify coordinator
            switch mode {
            case .create:
                coordinator.didSaveNewReceipt(receipt)
            case .edit:
                coordinator.didUpdateReceipt(receipt)
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isSaving = false
    }
    
    func delete() async {
           guard case .edit(let existing) = mode else { return }
           isSaving = true
           errorMessage = nil
           do {
               try dependencies.receiptRepository.delete(receipt: existing)
               coordinator.didDeleteReceipt(existing)
           } catch {
               errorMessage = error.localizedDescription
           }
           isSaving = false
       }

    func cancel() {
        coordinator.didCancelForm()
    }
}

extension ReceiptFormViewModel {
    struct Dependencies {
        let receiptRepository: ReceiptRepositoryProtocol

        static var defaultOption: Dependencies {
            .init(receiptRepository: ReceiptRepository())
        }
    }
}
