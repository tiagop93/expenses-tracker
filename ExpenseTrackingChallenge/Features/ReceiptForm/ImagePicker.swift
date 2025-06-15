//
//  ImagePicker.swift
//  ExpenseTrackingChallenge
//
//  Created by Tiago Pereira on 14/06/2025.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (Data) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            defer { parent.presentationMode.wrappedValue.dismiss() }
            guard let uiImage = info[.originalImage] as? UIImage,
                  let data = uiImage.jpegData(compressionQuality: 0.8)
            else { return }
            parent.onImagePicked(data)
        }
    }
}

enum ImageSource: Hashable {
    case camera
    case photoLibrary
    
    var uiImagePickerSourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera:
            return .camera
        case .photoLibrary:
            return .photoLibrary
        }
    }
}
