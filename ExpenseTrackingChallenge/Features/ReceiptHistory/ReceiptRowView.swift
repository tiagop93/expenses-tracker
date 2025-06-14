//
//  ReceiptRowView.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import SwiftUI

struct ReceiptRowView: View {
    let receipt: Receipt

    private var formattedDate: String {
        receipt.date.formattedMedium
    }

    private var formattedAmount: String {
        receipt.amount.formattedCurrency(code: receipt.currency)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let imageData = receipt.image,
               let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "doc.plaintext")
                            .foregroundColor(.gray)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(receipt.name)
                    .font(.headline)

                Text(formattedDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(formattedAmount)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
        .padding(.vertical, 4)
    }
}
