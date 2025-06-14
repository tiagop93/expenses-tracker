//
//  AppCoordinator.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 12/06/2025.
//

import SwiftUI

@MainActor @preconcurrency public protocol AppCoordinatorProtocol {
    var rootView: AnyView { get }
}

final class AppCoordinator: CoordinatorProtocol {
    
    // MARK: — Associated Types
    typealias Route = Routes.Push
    typealias Sheet = Routes.Sheet
    typealias FullScreenCover = Routes.FullScreenCover
    
    // MARK: — Protocol Properties
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    var mainView: some View {
        build(page: .receiptHistory)
    }
    
    private var imagePickerCompletion: ((Data) -> Void)?
    
    // MARK: — Build Methods
    @ViewBuilder
    func build(page: Route) -> some View {
        switch page {
        case .receiptHistory:
            ReceiptHistoryView(
                viewModel: ReceiptHistoryViewModel(
                    dependencies: .defaultOption,
                    coordinator: self
                )
            )
        case .receiptForm(let mode):
            ReceiptFormView(
                viewModel: ReceiptFormViewModel(
                    mode: mode,
                    dependencies: .defaultOption,
                    coordinator: self
                )
            )
        }
    }
    
    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        EmptyView()
    }
}

// MARK: - AppCoordinatorProtocol

extension AppCoordinator: AppCoordinatorProtocol {
    var rootView: AnyView {
        AnyView(AppRootView(coordinator: self))
    }
}

// MARK: - ReceiptHistoryCoordinatorProtocol

extension AppCoordinator: ReceiptHistoryCoordinatorProtocol {
    func goToCreateReceipt() {
        push(.receiptForm(mode: .create))
    }
    
    func goToEditReceipt(_ receipt: Receipt) {
        push(.receiptForm(mode: .edit(existing: receipt)))
    }
}

// MARK: - ReceiptFormCoordinatorProtocol

extension AppCoordinator: ReceiptFormCoordinatorProtocol {
    func presentImagePicker(
        source: ImageSource,
        onImagePicked: @escaping (Data) -> Void
    ) {
        imagePickerCompletion = onImagePicked
        sheet = .imagePicker(source: source.uiImagePickerSourceType)
    }
    
    func didSaveNewReceipt(_: Receipt) {
        pop()
    }
    
    func didUpdateReceipt(_: Receipt) {
        pop()
    }
    
    func didDeleteReceipt(_: Receipt) {
        pop()
    }
    
    func didCancelForm() {
        pop()
    }
}
