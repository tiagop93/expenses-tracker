//
//  ReceiptHistoryViewModel.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import Foundation

protocol ReceiptHistoryViewModelProtocol: ObservableObject {
    var state: ReceiptHistoryViewModel.State { get }
    
    func loadReceipts() async
    func loadNextPage() async
    
    func didPressCreateReceipt()
    func didPressReceipt(_ receipt: Receipt)
}

final class ReceiptHistoryViewModel: ReceiptHistoryViewModelProtocol {
    // MARK: - Models
    
    struct Pagination: Equatable {
        var currentPage: Int = 0
        let pageSize: Int = 15
        var isLoadingMore: Bool = false
        var isLastPage: Bool = false
    }
    
    struct PaginatedReceipts: Equatable {
        var receipts: [Receipt] = []
        var pagination = Pagination()
    }
    
    // MARK: - State
    
    enum State: Equatable {
        case idle
        case loading
        case loaded(PaginatedReceipts)
        case failed(String)
    }
    
    // MARK: - Published Properties
    
    @Published private(set) var state: State = .idle
    
    // MARK: - Dependencies
    
    private let dependencies: Dependencies
    private let coordinator: ReceiptHistoryCoordinatorProtocol
    
    // MARK: - Initialization
    
    init(
        dependencies: Dependencies = .defaultOption,
        coordinator: ReceiptHistoryCoordinatorProtocol
    ) {
        self.dependencies = dependencies
        self.coordinator = coordinator
    }
    
    // MARK: - Public API
    
    @MainActor
    func loadReceipts() async {
        state = .loading
        await loadPage(reset: true)
    }
    
    @MainActor
    func loadNextPage() async {
        guard case .loaded(let page) = state,
              !page.pagination.isLoadingMore,
              !page.pagination.isLastPage
        else { return }
        
        await loadPage(reset: false)
    }
    
    func didPressCreateReceipt() {
        coordinator.goToCreateReceipt()
    }
    
    func didPressReceipt(_ receipt: Receipt) {
        coordinator.goToEditReceipt(receipt)
    }
    
    // MARK: - Private API
    
    @MainActor
    private func loadPage(reset: Bool) async {
        var pageModel: PaginatedReceipts
        if reset {
            pageModel = PaginatedReceipts()
        } else if case .loaded(let existing) = state {
            pageModel = existing
            pageModel.pagination.isLoadingMore = true
        } else {
            pageModel = PaginatedReceipts()
        }
        
        if !reset {
            state = .loaded(pageModel)
        }
        
        do {
            let fetched = try await dependencies
                .receiptHistoryRepository
                .getReceipts(
                    page: pageModel.pagination.currentPage,
                    pageSize: pageModel.pagination.pageSize
                )
            
            if fetched.isEmpty {
                pageModel.pagination.isLastPage = true
            } else {
                pageModel.receipts += fetched
                pageModel.pagination.currentPage += 1
                pageModel.pagination.isLastPage =
                    (fetched.count < pageModel.pagination.pageSize)
            }
            pageModel.pagination.isLoadingMore = false
            state = .loaded(pageModel)
            
        } catch {
            state = .failed(String(describing: error))
        }
    }
}

extension ReceiptHistoryViewModel {
    // MARK: - Dependencies
    
    struct Dependencies {
        let receiptHistoryRepository: ReceiptRepositoryProtocol
        
        static var defaultOption: Dependencies {
            .init(receiptHistoryRepository: ReceiptRepository())
        }
    }
}
