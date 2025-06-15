//
//  ReceiptHistoryViewModelTests.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 15/06/2025.
//

import XCTest
@testable import ExpenseTrackingChallenge

final class ReceiptHistoryViewModelTests: XCTestCase {
    func testLoadReceiptsSuccess() async {
        let items = [Receipt(id: UUID(), name: "Receipt A", date: Date(), amount: 1, currency: "EUR", image: nil)]
        let repo = MockReceiptRepository(behavior: .success(items))
        let coordinator = MockHistoryCoordinator()
        let vm = ReceiptHistoryViewModel(dependencies: .init(receiptHistoryRepository: repo), coordinator: coordinator)
        
        await vm.loadReceipts()
        switch vm.state {
        case .success(let receipts):
            XCTAssertEqual(receipts, items)
        default:
            XCTFail("Expected success state")
        }
    }
    
    func testLoadReceiptsEmpty() async {
        let repo = MockReceiptRepository(behavior: .success([]))
        let coordinator = MockHistoryCoordinator()
        let vm = ReceiptHistoryViewModel(dependencies: .init(receiptHistoryRepository: repo), coordinator: coordinator)
        
        await vm.loadReceipts()
        XCTAssertEqual(vm.state, .empty)
    }
    
    func testLoadReceiptsFailure() async {
        let repo = MockReceiptRepository(behavior: .failure(TestError.sample))
        let coordinator = MockHistoryCoordinator()
        let vm = ReceiptHistoryViewModel(dependencies: .init(receiptHistoryRepository: repo), coordinator: coordinator)
        
        await vm.loadReceipts()
        if case .failed(let message) = vm.state {
            XCTAssertTrue(message.contains("sample"))
        } else {
            XCTFail("Expected failed state")
        }
    }
}
