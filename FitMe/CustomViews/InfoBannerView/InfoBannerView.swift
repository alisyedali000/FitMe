//
//  InfoBannerView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 21/12/2023.
//

import SwiftUI

struct InfoBannerView: FitMeBaseView {
    
    var text: String
    var color: Color = Color("AccentColor")
    
    var body: some View {
        
          
            
        HStack(alignment: .top) {
                Text("Note:")
                .font(.sansMedium(size: 12))
                .padding(.leading)

                Text(text)
                .font(.sansRegular(size: 11))

                Spacer()
        }.padding(3)
        .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(color.opacity(0.3), lineWidth: 1)
                        
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundColor(color.opacity(0.1))
                        
                }
            )
    }
}




#Preview {
    InfoBannerView(text: "you can quickly add your recipie in your today’s meal plan by selectiong today’ meal time")
}
