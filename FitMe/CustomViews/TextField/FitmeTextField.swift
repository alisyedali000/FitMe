//
//  FitmeTextField.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 28/12/2023.
//

import SwiftUI

struct FitmeTextField: FitMeBaseView {
    
     var placeholder: String
     var keyboardType : UIKeyboardType = .default
    @Binding var text: String
    
    @FocusState var isFocused: Bool
    
    
    var body: some View {
        
        loadView()
    }
}

extension FitmeTextField {
    
    func loadView() -> some View {
            
            ZStack(alignment: .trailing) {
                
                RoundedRectangle(cornerRadius: 12)
                    .frame(height: 52)
                    .foregroundStyle(textFieldColor)
                
                HStack {
                    TextField("", text: $text)
                        .placeholder(when: text.isEmpty, placeholder: {
                            Text(placeholder)
                                .foregroundStyle(.gray)
                        })
                        .keyboardType(keyboardType)
                        .focused($isFocused)
                        .font(.sansRegular(size: 14))
                        .tint(Color.redColor)
                        .foregroundStyle(isFocused ? Color.redColor : .black)
                        .frame(height: 52)
                        .padding(.leading)
                    
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.redColor : .clear, lineWidth: 1)
                    .transition(.opacity)
            )
    }
}


#Preview {
    FitmeTextField(placeholder: "Enter your number", keyboardType: .emailAddress, text: .constant(""))
}
