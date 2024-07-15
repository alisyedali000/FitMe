//
//  UIImageExtension.swift
//  FitMe
//
//  Created by Ali Syed on 07/12/2023.
//

import Foundation
import UIKit
import SwiftUI

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
    

        func resizedTo1MB() -> UIImage? {
            guard let imageData = self.pngData() else { return nil }
            let megaByte = 1000.0  // previous it was 1000.0

            var resizingImage = self
            var imageSizeKB = Double(imageData.count) / megaByte // ! Or devide for 1024 if you need KB but not kB

            while imageSizeKB > megaByte { // ! Or use 1024 if you need KB but not kB
                guard let resizedImage = resizingImage.resized(withPercentage: 0.5),
                      let imageData = resizedImage.pngData() else { return nil }

                resizingImage = resizedImage
                imageSizeKB = Double(imageData.count) / megaByte // ! Or devide for 1024 if you need KB but not kB
            }

            return resizingImage
        }
        func resized(withPercentage percentage: CGFloat) -> UIImage? {
            let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw(in: CGRect(origin: .zero, size: canvasSize))
            return UIGraphicsGetImageFromCurrentImageContext()
        }


}

extension UIImage {

    func resizeAndCompressImage() -> Data {
        guard let reducedImage = self.resizeImage() else {
            print("Image is not compressed")
            return Data()
        }

        guard let compressedImage = reducedImage.compressImage() else {
            print("image not compressed")
            return Data()
        }

        return compressedImage
    }

    func resizeImage() -> UIImage? {
        let targetHeight: CGFloat = min(self.size.height, 1200) // Change this value for smaller/bigger images
        let aspectRatio = self.size.width / self.size.height
        let targetWidth = targetHeight * aspectRatio

        let newSize = CGSize(width: targetWidth, height: targetHeight)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { context in
            self.draw(in: CGRect(origin: .zero, size: newSize))
                
        }

        return resizedImage
    }

    func compressImage() -> Data? {
        let targetSizeInKB = 500 // Change this value for smaller/bigger quality
        var compressionQuality: CGFloat = 1.0
        let maxSizeInBytes = targetSizeInKB * 1024 // Convert KB to bytes

        guard var compressedData = self.jpegData(compressionQuality: compressionQuality) else {
            return nil // Return nil if initial compression fails
        }

        while compressedData.count > maxSizeInBytes && compressionQuality > 0 {
            compressionQuality -= 0.05 // Adjust the compression quality

            guard let newCompressedData = self.jpegData(compressionQuality: compressionQuality) else {
                break // Break the loop if compression fails
            }

            compressedData = newCompressedData
        }

        return compressedData
    }
}

extension Image {
    init?(base64: String) {
        guard let data = Data(base64Encoded: base64),
              let uiImage = UIImage(data: data) else { return nil }
        self.init(uiImage: uiImage)
    }
}


