//
//  ReceiptFormCoordinatorProtocol.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

protocol ReceiptFormCoordinatorProtocol {
    func didSaveNewReceipt(_ receipt: Receipt)
    func didUpdateReceipt(_ receipt: Receipt)
    func didDeleteReceipt(_ receipt: Receipt)
    func didCancelForm()
}
