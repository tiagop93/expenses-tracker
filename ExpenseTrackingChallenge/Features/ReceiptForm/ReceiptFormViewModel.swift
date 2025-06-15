//
//  ReceiptFormViewModel.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import Foundation

protocol ReceiptFormViewModelProtocol: ObservableObject {
    var mode: ReceiptFormViewModel.Mode { get }
    var state: ReceiptFormViewModel.State { get }
    
    var name: String { get set }
    var date: Date { get set }
    var amount: Decimal { get set }
    var currency: String { get set }
    var image: Data? { get set }
    
    func save() async
    func delete() async
    func cancel()
    
    func presentImagePicker(source: ImageSource)
}

final class ReceiptFormViewModel: ReceiptFormViewModelProtocol {
    enum Mode: Hashable {
        case create
        case edit(existing: Receipt)
    }
    
    // MARK: - UI State
    enum State: Equatable {
        case idle
        case saving
        case saved
        case deleting
        case deleted
        case failed(String)
    }
    
    @Published var state: State = .idle
    
    // MARK: Form Fields
    @Published var name: String
    @Published var date: Date
    @Published var amount: Decimal
    @Published var currency: String
    @Published var image: Data?
    
    // MARK: Dependencies
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
    
    @MainActor
    func save() async {
        state = .saving
        
        let id: UUID = {
            switch mode {
            case .create:
                return UUID()
            case .edit(let existing):
                return existing.id
            }
        }()
        
        let receipt = Receipt(
            id: id,
            name: name,
            date: date,
            amount: amount,
            currency: currency,
            image: image
        )
        
        do {
            try await dependencies.receiptRepository.save(receipt: receipt)
            state = .saved
            switch mode {
            case .create:
                coordinator.didSaveNewReceipt(receipt)
            case .edit:
                coordinator.didUpdateReceipt(receipt)
            }
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
    
    @MainActor
    func delete() async {
        guard case .edit(let existing) = mode else { return }
        state = .deleting
        do {
            try await dependencies.receiptRepository.delete(receipt: existing)
            state = .deleted
            coordinator.didDeleteReceipt(existing)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
    
    func cancel() {
        coordinator.didCancelForm()
    }
    
    func presentImagePicker(source: ImageSource) {
        Task { @MainActor in
            coordinator.presentImagePicker(source: source) { [weak self] data in
                self?.image = data
            }
        }
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
