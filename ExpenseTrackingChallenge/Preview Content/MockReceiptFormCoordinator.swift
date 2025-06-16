//
//  MockReceiptFormCoordinator.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import Foundation

final class MockReceiptFormCoordinator: ReceiptFormCoordinatorProtocol {
    func presentImagePicker(source: ImageSource, onImagePicked: @escaping (Data) -> Void) {}
    func didSaveNewReceipt(_: Receipt) {}
    func didUpdateReceipt(_: Receipt) {}
    func didDeleteReceipt(_: Receipt) {}
    func didCancelForm() {}
}
