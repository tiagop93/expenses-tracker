//
//  ReceiptHistoryView.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import SwiftUI

struct ReceiptHistoryView<ViewModel: ReceiptHistoryViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .idle, .loading:
                ProgressView("Loading Receipts...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            case .failed(let message):
                VStack(spacing: 8) {
                    Text("Error:")
                        .bold()
                    Text(message)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                    Button("Retry") {
                        Task { await viewModel.loadReceipts() }
                    }
                }
                .padding()
                
            case .loaded(let page):
                if page.receipts.isEmpty {
                    VStack {
                        Text("No receipts found.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Button("Add Receipt") {
                            viewModel.didPressCreateReceipt()
                        }
                    }
                    .padding()
                } else {
                    List {
                        ForEach(page.receipts, id: \.id) { receipt in
                            ReceiptRowView(receipt: receipt)
                                .onTapGesture {
                                    viewModel.didPressReceipt(receipt)
                                }
                                .onAppear {
                                    if receipt == page.receipts.last {
                                        Task { await viewModel.loadNextPage() }
                                    }
                                }
                        }
                        
                        if page.pagination.isLoadingMore {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
        }
        .navigationTitle("Receipts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.didPressCreateReceipt()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            Task { await viewModel.loadReceipts() }
        }
    }
}

#Preview {
    let coord = AppCoordinator()
    CoordinatorRootView(coordinator: coord)
}
