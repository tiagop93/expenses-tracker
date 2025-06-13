//
//  AppCoordinator.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import SwiftUI

final class AppCoordinator: ObservableObject {
    @Published var path: [Screen] = []
    
    enum Screen: Hashable {
        case receiptHistory
        case receiptDetauls(id: UUID)
        case captureReceipt
    }
    
    @ViewBuilder
    func view(for screen: Screen) -> some View {
        switch screen {
        case .receiptHistory:
            ReceiptHistoryView(
                viewModel: ReceiptHistoryViewModel(
                    dependencies: .defaultOption,
                    coordinator: self
                )
            )
        case .receiptDetauls(let id):
            ReceiptDetailsView()
        case .captureReceipt:
            CaptureReceiptView()
        }
    }
    
    func push(_ screen: Screen) {
        path.append(screen)
    }

    func pop() {
        _ = path.popLast()
    }
}

extension AppCoordinator: ReceiptHistoryCoordinatorProtocol {
    func goToCaptureReceipt() {
        push(.captureReceipt)
    }
    
    func goToReceiptDetails(id: UUID) {
        push(.receiptDetauls(id: id))
    }
}

extension AppCoordinator: CaptureReceiptCoordinatorProtocol {
    func goBackToHistory() {
        pop()
    }
}
