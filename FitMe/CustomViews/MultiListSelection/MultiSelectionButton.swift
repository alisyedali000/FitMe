//
//  MultiSelectionButton.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 21/12/2023.
//

import SwiftUI

struct MultiListSelectionButton: FitMeBaseView {
    
    var title: String
    var isSelected: Bool
    var action: (String) -> ()
    
    
    var body: some View {
        loadView
    }
}

// MARK: View Extension

extension MultiListSelectionButton {
    var loadView: some View {
        Button(action: {
            action(title)
        }, label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 40)
                    .foregroundStyle(isSelected ? primaryColor : textFieldColor)
                
                HStack {
                    Text(title)
                        .foregroundStyle(isSelected ? .white : .textGray)
                        .font(.sansRegular(size: 13))
                    Spacer()
                    
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .scaledToFit()
                        .foregroundStyle(isSelected ?  .white : .textGray)
                        
                }.padding(.horizontal)
                
            }
        })
    }
}

#Preview {
    MultiListSelectionButton(title: "Monday", isSelected: false) { _ in
        
    }
}
