//
//  MockReceiptFormCoordinator.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import Foundation

final class MockReceiptFormCoordinator: ReceiptFormCoordinatorProtocol {
    func didSaveNewReceipt(_: Receipt) {
        // No action for preview
    }
    
    func didUpdateReceipt(_: Receipt) {
        // No action for preview
    }
    
    func didDeleteReceipt(_: Receipt) {
        // No action for preview
    }
    
    func didCancelForm() {
        // No action for preview
    }
}
