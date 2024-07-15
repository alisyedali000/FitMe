//
//  EmptyLocation.swift
//  Koy
//
//  Created by Taimoor Arif on 02/10/2023.
//

import SwiftUI

struct EmptyViewFitMe: View {
    
    private var image: Image
    private var title: String
    private var description: String
    private var imageHeight: CGFloat
    private var imageWidth: CGFloat
    
    init(image: Image, title: String, description: String, imageWidth: CGFloat, imageHeight: CGFloat) {
        self.image = image
        self.title = title
        self.description = description
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
    }
    
    var body: some View {
        
        loadView()
    }
}

extension EmptyViewFitMe {
    
    func loadView() -> some View {
        
        VStack(spacing: 10) {
            
            VStack(spacing: 20, content: {
                
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageWidth, height: imageHeight)
                
                Text(title)
//                    .font(.sansMedium(size: 18))
                    .foregroundStyle(.white)
            })
            
            Text(description)
//                .font(.sansRegular(size: 12))
//                .foregroundStyle(Color.whiteTextColor)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    EmptyViewFitMe(image: Image(""), title: "Turn location on", description: "please turn the location on", imageWidth: 218, imageHeight: 190)
}
