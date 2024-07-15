//
//  PhotoPicker.swift
//  Unified
//
//  Created by Qazi Ammar Arshad on 14/07/2022.
//

import Foundation
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PHPickerViewController
    
    private var selectionLimit: Int
    @Binding private var showLoader: Bool
    private var filter: PHPickerFilter?
    private var itemProviders: [NSItemProvider] = []
    private var onImagePicked: ([UIImage], [String]) -> Void

    init(selectionLimit: Int, showLoader: Binding<Bool>, filter: PHPickerFilter? = nil, onImagePicked: @escaping ([UIImage], [String]) -> Void) {
        
        self.selectionLimit = selectionLimit
        self._showLoader = showLoader
        self.filter = filter
        self.onImagePicked = onImagePicked
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = self.selectionLimit
        //        configuration.filter = self.filter
        configuration.filter = .images
    
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        return PhotoPicker.Coordinator(parent: self, showLoader: $showLoader, onImagePicked: self.onImagePicked)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {

        private var parent: PhotoPicker
        private var onImagePicked: ([UIImage], [String]) -> Void
        @Binding private var showLoader: Bool
        
        init(parent: PhotoPicker, showLoader: Binding<Bool>, onImagePicked: @escaping ([UIImage], [String]) -> Void) {

            self.parent = parent
            self._showLoader = showLoader
            self.onImagePicked = onImagePicked
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Dismiss picker
            self.showLoader = true
            
            if results.isEmpty {
                parent.itemProviders = []
                self.showLoader = false
                picker.dismiss(animated: true)
                return
            }

            parent.itemProviders = results.map(\.itemProvider)
            
            self.loadImage()
            picker.dismiss(animated: true)
        }
        
       @MainActor private func loadImage() {

            let dispatchGroup = DispatchGroup()
            var processedResults = [UIImage]()
            var pictureNames = [String]()

            for itemProvider in parent.itemProviders {
                dispatchGroup.enter()

                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in


                        if let fileName = itemProvider.suggestedName {
                            pictureNames.append(fileName)
                        }

                        if let image = image as? UIImage {
                            processedResults.append(image)
//                             self.parent.images.append(image)

                        } else {
                            print("Could not load image", error?.localizedDescription ?? "")
                        }

                        dispatchGroup.leave()
                    }
                }
            }

           dispatchGroup.notify(queue: .global(qos: .userInitiated)) {
                self.onImagePicked(processedResults, pictureNames)
            }
        }
    }
}

struct MultiImage: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PHPickerViewController
    
    var selectionLimit: Int
    var onImagePicked: ([UIImage], [String]) -> Void
    
    init(selectionLimit: Int, onImagePicked: @escaping ([UIImage], [String]) -> Void) {
        
        self.selectionLimit = selectionLimit
        self.onImagePicked = onImagePicked
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = self.selectionLimit
        //        configuration.filter = self.filter
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        MultiImage.Coordinator(parent: self, onImagePicked: self.onImagePicked)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
        
        var parent: MultiImage
        var onImagePicked: ([UIImage], [String]) -> Void
        
        init(parent: MultiImage, onImagePicked: @escaping ([UIImage], [String]) -> Void) {
            self.parent = parent
            self.onImagePicked = onImagePicked
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            //            picker.dismiss(animated: true)
            
            var allImages : [UIImage] = []
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
//                            selectedImages.append(image)
                            allImages.append(image)
                        }
                    }
                }
            }
            picker.dismiss(animated: true)
        }
    }
}
