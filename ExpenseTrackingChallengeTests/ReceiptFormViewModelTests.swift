//
//  ReceiptFormViewModelTests.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 15/06/2025.
//

import XCTest
@testable import ExpenseTrackingChallenge

final class ReceiptFormViewModelTests: XCTestCase {
    func testCreateSaveSuccess() async throws {
        let repo = MockReceiptRepository(behavior: .success([]))
        let coord = MockFormCoordinator()
        let vm = ReceiptFormViewModel(
            mode: .create,
            dependencies: .init(receiptRepository: repo),
            coordinator: coord
        )
        
        vm.name = "Train Ticket"
        vm.amount = 12.50
        vm.currency = "EUR"

        await vm.save()
        
        XCTAssertEqual(vm.state, .saved)
        
        XCTAssertNotNil(coord.saved)
        XCTAssertEqual(coord.saved?.name, "Train Ticket")
        XCTAssertEqual(coord.saved?.amount, 12.50)
        XCTAssertEqual(coord.saved?.currency, "EUR")
    }
    
    func testDeleteSuccess() async throws {
        let existing = Receipt(
            id: UUID(),
            name: "Taxi",
            date: Date(),
            amount: 8.00,
            currency: "EUR",
            image: nil
        )
        let repo = MockReceiptRepository(behavior: .success([]))
        let coord = MockFormCoordinator()
        let vm = ReceiptFormViewModel(
            mode: .edit(existing: existing),
            dependencies: .init(receiptRepository: repo),
            coordinator: coord
        )

        await vm.delete()

        XCTAssertEqual(vm.state, .deleted)
        XCTAssertEqual(coord.deleted?.id, existing.id)
    }

    func testSaveFailure() async throws {
        let repo = MockReceiptRepository(behavior: .failure(TestError.sample))
        let coord = MockFormCoordinator()
        let vm = ReceiptFormViewModel(
            mode: .create,
            dependencies: .init(receiptRepository: repo),
            coordinator: coord
        )
        vm.name = "Error Receipt"
        vm.amount = 5.00

        await vm.save()

        if case .failed(let msg) = vm.state {
            XCTAssertTrue(msg.contains("sample"))
        } else {
            XCTFail("Expected .failed state on repository error")
        }
    }
}
