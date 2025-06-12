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
        case captureReceipt
    }
    
    @ViewBuilder
    func view(for screen: Screen) -> some View {
        switch screen {
        case .receiptHistory:
            ReceiptHistoryView()
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

extension AppCoordinator: ReceiptHistoryCoordinatorProtocol, CaptureReceiptCoordinatorProtocol {
    func goToCaptureReceipt() {
        push(.captureReceipt)
    }

    func goBackToHistory() {
        pop()
    }
}

protocol ReceiptHistoryCoordinatorProtocol {
    func goToCaptureReceipt()
}

protocol CaptureReceiptCoordinatorProtocol {
    func goBackToHistory()
}

