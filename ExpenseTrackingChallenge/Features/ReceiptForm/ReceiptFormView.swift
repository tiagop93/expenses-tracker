//
//  ReceiptFormview.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 13/06/2025.
//

import SwiftUI

struct ReceiptFormView<ViewModel: ReceiptFormViewModelProtocol>: View {
    @ObservedObject private var viewModel: ViewModel
    
    @State private var showingImageSourceChooser = false
    @State private var showingImagePicker = false
    @State private var imageSource: ImageSource = .photoLibrary
    
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
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.words)
                DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                HStack {
                    TextField(
                        "Amount",
                        value: $viewModel.amount,
                        format: .number
                    )
                    .autocorrectionDisabled(true)
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
                        .onTapGesture {
                            Task { @MainActor in
                                showingImageSourceChooser = true
                            }
                        }
                } else {
                    Button("Add Photo") {
                        Task { @MainActor in
                            showingImageSourceChooser = true
                        }
                    }
                }
            }
            
            if case .failed(let message) = viewModel.state {
                Section {
                    Text(message)
                        .foregroundColor(.red)
                }
            }
            
            if case .edit = viewModel.mode {
                Section {
                    if viewModel.state == .deleting {
                        ProgressView()
                    } else {
                        Button("Delete Receipt", role: .destructive) {
                            Task { await viewModel.delete() }
                        }
                        .disabled(viewModel.state == .deleting)
                    }
                }
            }
        }
        .navigationBarTitle(title, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.state == .saving {
                    ProgressView()
                } else {
                    Button {
                        Task { await viewModel.save() }
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(viewModel.name.isEmpty)
                }
            }
        }
        .confirmationDialog(
            viewModel.mode == .create ? "Add Receipt Photo" : "Replace Receipt Photo",
            isPresented: $showingImageSourceChooser,
            titleVisibility: .visible
        ) {
            Button("Take Photo") {
                Task { @MainActor in
                    imageSource = .camera
                    showingImagePicker = true
                }
            }
            Button("Choose from Library") {
                Task { @MainActor in
                    imageSource = .photoLibrary
                    showingImagePicker = true
                }
            }
            Button("Cancel", role: .cancel) { }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(sourceType: imageSource.uiImagePickerSourceType) { data in
                Task { @MainActor in
                    viewModel.image = data
                    showingImagePicker = false
                }
            }
        }
    }
}

#Preview {
    let mode: ReceiptFormViewModel.Mode = .create
    let viewModel = ReceiptFormViewModel(mode: mode, dependencies: .defaultOption, coordinator: AppCoordinator())
    NavigationStack {
        ReceiptFormView(viewModel: viewModel)
    }
}
