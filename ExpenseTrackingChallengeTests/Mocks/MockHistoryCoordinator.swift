//
//  MockHistoryCoordinator.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 15/06/2025.
//

@testable import ExpenseTrackingChallenge

// MARK: - Mock Coordinators
class MockHistoryCoordinator: ReceiptHistoryCoordinatorProtocol {
    var didNavigateToCreate = false
    var didNavigateToEdit: Receipt?
    
    func goToCreateReceipt() {
        didNavigateToCreate = true
    }
    
    func goToEditReceipt(_ receipt: Receipt) {
        didNavigateToEdit = receipt
    }
}
