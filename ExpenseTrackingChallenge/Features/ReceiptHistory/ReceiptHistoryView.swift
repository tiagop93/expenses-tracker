//
//  ReceiptHistoryView.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import SwiftUI

struct ReceiptHistoryView<ViewModel: ReceiptHistoryViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                Color.clear.onAppear { viewModel.loadReceipts() }
            case .loading:
                ProgressView("Loading Receipts...")
            case .success(let receipts):
                List(receipts, id: \.id) { receipt in
                    ReceiptRowView(receipt: receipt)
                        .onTapGesture {
                            
                        }
                }
            case .empty:
                VStack {
                    Text("No receipts found.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Button("Add Receipt") {
                        viewModel.didPressCaptureReceipt()
                    }
                }
            case .failed(let message):
                VStack(spacing: 8) {
                    Text("Error:")
                        .bold()
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                    Button("Retry") {
                        viewModel.loadReceipts()
                    }
                }
            }
        }
        .navigationTitle("Receipts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.didPressCaptureReceipt()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

#Preview {
    let viewModel = ReceiptHistoryViewModel(
        dependencies: .mock,
        coordinator: MockReceiptHistoryCoordinator()
    )
    NavigationStack {
        ReceiptHistoryView(viewModel: viewModel)
    }
}
