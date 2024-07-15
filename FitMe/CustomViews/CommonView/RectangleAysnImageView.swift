//
//  CommonView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 19/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct RectangleAysnImageView: View {
    let url: String
    
    var cornerRadius = 10.0
    var showOverlay = true
    
    var body: some View {
        
        WebImage(url: URL(string: AppUrl.IMAGEURL + (url))!)
            .resizable()
            .placeholder(Image(ImageName.Common.thumb.rawValue))
            .indicator(.activity)
            .transition(.fade(duration: 0.5)) // Fade Transition with duration
            .overlay {
                if showOverlay {
                    Rectangle()
                        .foregroundStyle(.black)
                        .opacity(0.5)
                }
            }
            .cornerRadius(cornerRadius, corners: .allCorners)
    }
}


#Preview {
    RectangleAysnImageView(url: mockRecipes.first?.image ?? "")
}



