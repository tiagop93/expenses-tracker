//
//  MockFormCoordinator.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 15/06/2025.
//

import Foundation
@testable import ExpenseTrackingChallenge

class MockFormCoordinator: ReceiptFormCoordinatorProtocol {
    var saved: Receipt?
    var updated: Receipt?
    var deleted: Receipt?
    var didCancel = false

    func presentImagePicker(source: ImageSource, onImagePicked: @escaping (Data) -> Void) {}
    
    func didSaveNewReceipt(_ receipt: Receipt) {
        saved = receipt
    }
    func didUpdateReceipt(_ receipt: Receipt) {
        updated = receipt
    }
    func didDeleteReceipt(_ receipt: Receipt) {
        deleted = receipt
    }
    func didCancelForm() {
        didCancel = true
    }
}
