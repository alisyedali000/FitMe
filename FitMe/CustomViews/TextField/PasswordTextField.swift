//
//  PasswordTextField.swift
//  Unified
//
//  Created by Qazi Ammar Arshad on 07/07/2022.
//

import SwiftUI

struct PasswordTextField: View {
    @State var image : Image
    var placeHolder = ""
    @Binding var text: String
    @State var isSecure = true
    @FocusState private var secureFocused: Bool
    @FocusState private var normalFocused: Bool

    init(placeHolder: String, image: Image,text: Binding<String>) {
        self.placeHolder = placeHolder
        self._text = text
        self.image = image
    }
    
    var body: some View {
        
        ZStack(alignment: .trailing) {
            
            Group {
                isSecure ? AnyView(secureTF()) : AnyView( normalTF())
            }
            
            Button {
                
                
                withAnimation {
                    
                    isSecure.toggle()
                }
                
                if isSecure {
                    secureFocused = true
                } else {
                    normalFocused = true
                }
                
            } label: {
                
                let isFocused = secureFocused == true || normalFocused == true ? true : false

                let img: Image = isSecure ? ImageName.eyeClosed : image
                img
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(isFocused ? Color.redColor : Color.grayImages)
                    .padding(.trailing)
                
            }
        }
    }
    
    
    func secureTF() -> some View {
        
        VStack {
            
            let isFocused = secureFocused == true || normalFocused == true ? true : false
            
            SecureField(placeHolder, text: $text)
                .font(.sansRegular(size: 14))
                .focused($secureFocused)
                .padding(15)
                .tint(Color.redColor)
                .foregroundColor(isFocused ? Color.redColor : .black)
                .cornerRadius(12)
                .frame(height: 52)
                .background(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.textfieldBackground)
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? Color.redColor : .clear, lineWidth: 1)
                        .transition(.opacity)
                )
        }
    }
    
    func normalTF() -> some View {
        
        VStack {
            
            let isFocused = secureFocused == true || normalFocused == true ? true : false
            
            TextField(placeHolder, text: $text)
                .font(.sansRegular(size: 14))
                .padding(15)
                .focused($normalFocused)
                .tint(Color.redColor)
                .foregroundColor(isFocused ? Color.redColor : .black)
                .cornerRadius(12)
                .frame(height: 52)
                .background(content: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.textfieldBackground)
                })
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isFocused ? Color.redColor : .clear, lineWidth: 1)
                        .transition(.opacity)
                )
        }
    }
}

struct PasswordTextField_Previews: PreviewProvider {
    static var previews: some View {
        PasswordTextField(placeHolder: "password", image: ImageName.eye, text: .constant("123"))
    }
}
