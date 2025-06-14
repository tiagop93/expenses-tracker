//
//  ReceiptFormview.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import SwiftUI

struct ReceiptFormView<ViewModel: ReceiptFormViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private var title: String {
        switch viewModel.mode {
        case .create:
            return "New Receipt"
        case .edit:
            return "Edit Receipt"
        }
    }

    var body: some View {
        Form {
            Section(header: Text("Details")) {
                TextField("Name", text: $viewModel.name)
                DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                HStack {
                    TextField(
                        "Amount",
                        value: $viewModel.amount,
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    Spacer()
                    Text(viewModel.currency)
                }
            }

            Section(header: Text("Image")) {
                if let data = viewModel.image,
                   let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } else {
                    Button(action: {
                        // TODO: Present image picker
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Add Photo")
                        }
                    }
                }
            }

            if let error = viewModel.errorMessage {
                Section {
                    Text(error)
                        .foregroundColor(.red)
                }
            }
            
            if case .edit = viewModel.mode {
                           Section {
                               Button("Delete Receipt", role: .destructive) {
                                   Task { await viewModel.delete() }
                               }
                           }
                       }
        }
        .navigationBarTitle(title, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isSaving {
                    ProgressView()
                } else {
                    Button(action: {
                        Task { await viewModel.save() }
                    }) {
                        Image(systemName: "checkmark")
                    }
                    .disabled(viewModel.name.isEmpty)
                }
            }
        }
    }
}

#Preview {
    let viewModel = ReceiptFormViewModel(mode: .create, dependencies: .defaultOption, coordinator: MockReceiptFormCoordinator())
    NavigationStack {
        ReceiptFormView(viewModel: viewModel)
    }
}
