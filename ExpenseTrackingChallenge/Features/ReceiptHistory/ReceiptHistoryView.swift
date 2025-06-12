//
//  ReceiptHistoryView.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import SwiftUI

struct ReceiptHistoryView: View {
    @ObservedObject var viewModel: ReceiptHistoryViewModel
    
    var body: some View {
        Text("Receipt History View")
        VStack {
            List(viewModel.receipts, id: \.self) { receipt in
                Text(receipt)
            }
        }
    }
}

#Preview {
    ReceiptHistoryView(viewModel: ReceiptHistoryViewModel(dependencies: .defaultOption))
}
