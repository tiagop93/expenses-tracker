//
//  MockReceiptRepository.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 15/06/2025.
//

@testable import ExpenseTrackingChallenge

// MARK: - Mock Repository
class MockReceiptRepository: ReceiptRepositoryProtocol {
    enum Behavior {
        case success([Receipt])
        case failure(Error)
    }

    var behavior: Behavior

    init(behavior: Behavior) {
        self.behavior = behavior
    }

    func getReceipts() async throws -> [Receipt] {
        switch behavior {
        case .success(let receipts): return receipts
        case .failure(let error): throw error
        }
    }

    func save(receipt: Receipt) async throws {
        switch behavior {
        case .success: return
        case .failure(let error): throw error
        }
    }

    func delete(receipt: Receipt) async throws {
        switch behavior {
        case .success: return
        case .failure(let error): throw error
        }
    }
}
