//
//  ReceiptRepositoryTests.swift
//  ExpenseTrackingChallengeTests
//
//  Created by Tiago Pereira on 15/06/2025.
//

import XCTest
import CoreData
@testable import ExpenseTrackingChallenge

final class ReceiptRepositoryTests: XCTestCase {
    var persistence: MockCoreDataController!
    var repository: ReceiptRepositoryProtocol!
    
    override func setUp() {
        super.setUp()
        persistence = MockCoreDataController()
        repository = ReceiptRepository(persistence: persistence)
    }
    
    override func tearDown() {
        repository = nil
        persistence = nil
        super.tearDown()
    }
    
    func testSaveAndFetchReceipt() async throws {
        let receipt = Receipt(
            id: UUID(),
            name: "Test Receipt",
            date: Date(),
            amount: 10.0,
            currency: "EUR",
            image: nil
        )
        try await repository.save(receipt: receipt)
        
        let receipts = try await repository.getReceipts(page: 0, pageSize: 15)
        XCTAssertEqual(receipts.count, 1)
        XCTAssertEqual(receipts.first, receipt)
    }
    
    func testUpdateReceipt() async throws {
        let id = UUID()
        let original = Receipt(
            id: id,
            name: "Original Receipt",
            date: Date(),
            amount: 5.0,
            currency: "EUR",
            image: nil
        )
        try await repository.save(receipt: original)
        
        var updated = original
        updated.name = "Updated Receipt"
        try await repository.save(receipt: updated)
        
        let receipts = try await repository.getReceipts(page: 0, pageSize: 15)
        XCTAssertEqual(receipts.count, 1)
        XCTAssertEqual(receipts.first?.name, "Updated Receipt")
    }
    
    func testDeleteReceipt() async throws {
        let receipt = Receipt(
            id: UUID(),
            name: "Receipt to Delete",
            date: Date(),
            amount: 1.0,
            currency: "EUR",
            image: nil
        )
        try await repository.save(receipt: receipt)
        try await repository.delete(receipt: receipt)
        
        let receipts = try await repository.getReceipts(page: 0, pageSize: 15)
        XCTAssertTrue(receipts.isEmpty)
    }
}
