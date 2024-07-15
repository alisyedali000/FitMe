//
//  DropDownButtonView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 16/01/2024.
//

import SwiftUI

struct DropDownButton: FitMeBaseView {

    var title: String
    @Binding var isShown: Bool
    
    var body: some View {
        Button {
            withAnimation {
                isShown.toggle()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color.textfieldBackground)
                    .frame(height: 50)
                HStack {
                    
                    Text(title)
                        .font(.sansRegular(size: 14))
                        .foregroundColor(.gray)
                    
                    
                    Spacer()
                    Image(systemName: isShown ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                        .frame(width: 30,height: 30)
                }.padding()
            }
        }
        
    }
}

#Preview {
    DropDownButton(title: "Preference", isShown: .constant(true))
}
