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
        let items = [
            Receipt(
                id: UUID(),
                name: "Receipt A",
                date: Date(),
                amount: 1,
                currency: "EUR",
                image: nil
            )
        ]
        let repo = MockReceiptRepository(behavior: .success(items))
        let coordinator = MockHistoryCoordinator()
        let vm = ReceiptHistoryViewModel(
            dependencies: .init(receiptHistoryRepository: repo),
            coordinator: coordinator
        )
        
        await vm.loadReceipts()
        
        switch vm.state {
        case .loaded(let page):
            // payload
            XCTAssertEqual(page.receipts, items)
            XCTAssertTrue(page.pagination.isLastPage)
            XCTAssertFalse(page.pagination.isLoadingMore)
            XCTAssertEqual(page.pagination.currentPage, 1)
            
        default:
            XCTFail("Expected .loaded with items, got \(vm.state) instead")
        }
    }
    
    func testLoadReceiptsEmpty() async {
        let repo = MockReceiptRepository(behavior: .success([]))
        let coordinator = MockHistoryCoordinator()
        let vm = ReceiptHistoryViewModel(
            dependencies: .init(receiptHistoryRepository: repo),
            coordinator: coordinator
        )
        
        await vm.loadReceipts()
        
        switch vm.state {
        case .loaded(let page):
            XCTAssertTrue(page.receipts.isEmpty, "Expected no receipts")
            XCTAssertTrue(page.pagination.isLastPage, "Empty fetch should mark last page")
            XCTAssertEqual(page.pagination.currentPage, 0,
                           "currentPage should remain 0 when nothing is fetched")
            XCTAssertFalse(page.pagination.isLoadingMore,
                           "Should not be loading more after empty result")
        default:
            XCTFail("Expected .loaded(empty) state, got \(vm.state) instead")
        }
    }
    
    func testLoadReceiptsFailure() async {
        let repo = MockReceiptRepository(behavior: .failure(TestError.sample))
        let coordinator = MockHistoryCoordinator()
        let vm = ReceiptHistoryViewModel(
            dependencies: .init(receiptHistoryRepository: repo),
            coordinator: coordinator
        )
        
        await vm.loadReceipts()
        
        if case .failed(let message) = vm.state {
            XCTAssertTrue(message.contains("sample"),
                          "Error message should mention underlying error, got: \(message)")
        } else {
            XCTFail("Expected .failed state, got \(vm.state) instead")
        }
    }
}
