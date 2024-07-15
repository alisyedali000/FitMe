//
//  ImagePicker.swift
//  BattleRap
//
//  Created by Qazi Ammar Arshad on 01/04/2022.
//

import Foundation
import SwiftUI

public struct ImagePickerView: UIViewControllerRepresentable {

    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage, String?) -> Void
    private let allowsEditing : Bool
    @Environment(\.presentationMode) private var presentationMode

    public init(allowsEditing: Bool, sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage, String?) -> Void) {

        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
        self.allowsEditing = allowsEditing
    }

    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = allowsEditing
        
        return picker
    }

    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
        )
    }

    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage, String?) -> Void

        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage, String?) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }

        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            
            picker.dismiss(animated: true)
            
            if let img = info[.editedImage] as? UIImage {
                
                let imageName = getImageName(from: info)
                self.onImagePicked(img, imageName)
                
            } else if let image = info[.originalImage] as? UIImage {
                let imageName = getImageName(from: info)
                self.onImagePicked(image, imageName)
            }
        }
        
        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }
        
        private func getImageName(from info: [UIImagePickerController.InfoKey: Any]) -> String? {
            if let imageUrl = info[.imageURL] as? URL {
                return imageUrl.lastPathComponent
            }
            return nil
        }
    }

}
