//
//  CustomTextField.swift
//  Koy
//
//  Created by Taimoor Arif on 27/09/2023.
//

import SwiftUI

struct CustomTextField: FitMeBaseView {
    
    private var placeholder: String
    private var image: Image
    private var keyboardType : UIKeyboardType = .default
    @Binding private var text: String
    
    @FocusState private var isFocused: Bool
    
    init(placeholder: String, image: Image, text: Binding<String>, keyboardType : UIKeyboardType = .default) {
        
        self.placeholder = placeholder
        self.image = image
        self._text = text
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        
        loadView()
    }
}

extension CustomTextField {
    
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
                    
                    image
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(isFocused ? Color.redColor : Color.grayImages)
                        .padding(.trailing)
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
    CustomTextField(placeholder: "Enter your number", image: ImageName.eye, text: .constant(""), keyboardType: .emailAddress)
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
