//
//  Routes.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 14/06/2025.
//

import UIKit

enum Routes {
    enum Push: Hashable {
        case receiptHistory
        case receiptForm(mode: ReceiptFormViewModel.Mode)
    }

    enum Sheet: Hashable, Identifiable {
        case imagePicker(source: UIImagePickerController.SourceType)
        
        var id: Self { self }
    }

    enum FullScreenCover: Hashable, Identifiable {
        case fullScreenCover
        
        var id: Self { self }
    }
}
