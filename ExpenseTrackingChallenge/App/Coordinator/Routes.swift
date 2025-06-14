//
//  Routes.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 14/06/2025.
//

enum Routes {
    enum Push: Hashable {
        case receiptHistory
        case receiptForm(mode: ReceiptFormViewModel.Mode)
    }

    enum Sheet: Hashable, Identifiable {
        case sheet
        
        var id: Self { self }
    }

    enum FullScreenCover: Hashable, Identifiable {
        case fullScreen
        
        var id: Self { self }
    }
}
