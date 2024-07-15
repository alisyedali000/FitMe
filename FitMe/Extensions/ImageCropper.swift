////
////  ImageCropper.swift
////  FitMe
////
////  Created by Ali Syed on 14/12/2023.
////
//
//import Foundation
//
//import SwiftUI
////import Mantis
//
//struct ImageCropper: UIViewControllerRepresentable {
//
//    @Binding var image: UIImage?
//    var completion: (UIImage) -> Void
//    var cancelCropView: () -> Void
//    @Environment(\.presentationMode) var presentationMode
//
//    func makeUIViewController(context: Context) -> CropViewController {
//        var config = Mantis.Config()
//        config.cropViewConfig.cropShapeType = .rect
//        config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: 1.3)
//        let cropViewController = Mantis.cropViewController(image: image ?? UIImage(),
//                                                           config: config)
//        cropViewController.delegate = context.coordinator
//        return cropViewController
//    }
//
//    func updateUIViewController(_ uiViewController: CropViewController, context: Context) {
//
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self, cancelCropView: cancelCropView)
//    }
//    
//    class Coordinator: CropViewControllerDelegate {
//
//        var parent: ImageCropper
//        var cancelCrop: () -> Void
//        
//        init(_ parent: ImageCropper, cancelCropView: @escaping () -> Void) {
//            self.parent = parent
//            self.cancelCrop = cancelCropView
//        }
//
//        func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation, cropInfo: CropInfo) {
//            parent.image = cropped
//            parent.completion(cropped)
//            debugPrint("transformation is \(transformation)")
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//        func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
//            cancelCrop()
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//
//        func cropViewControllerDidImageTransformed(_ cropViewController: CropViewController) {
//
//        }
//        
//        func cropViewControllerDidFailToCrop(_ cropViewController: CropViewController, original: UIImage) {
//        }
//
//        func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) {
//        }
//
//        func cropViewControllerDidEndResize(_ cropViewController: CropViewController, original: UIImage, cropInfo: CropInfo) {
//        }
//    }
//}
//
