//
//  ReceiptHistoryCoordinatorProtocol.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import Foundation

protocol ReceiptHistoryCoordinatorProtocol {
    func goToCaptureReceipt()
    func goToReceiptDetails(id: UUID)
}

final class MockReceiptHistoryCoordinator: ReceiptHistoryCoordinatorProtocol {
    func goToCaptureReceipt() {
        // No action for preview
    }
    
    func goToReceiptDetails(id: UUID) {
        // No action for preview
    }
}
