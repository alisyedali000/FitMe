//
//  CustomTextEditor.swift
//  myMufti
//
//  Created by Taimoor Arif on 01/03/2023.
//

import SwiftUI

struct CustomTextEditor: View {
    
    @Binding var text: String
    private var placeholder: String
    private var height: CGFloat
    
    init(text: Binding<String>, placeholder: String, height: CGFloat) {
        self._text = text
        self.placeholder = placeholder
        self.height = height
    }
    
    var body: some View {
              
        VStack(alignment: .leading, spacing: 5) {
            
            ZStack(alignment: .topLeading) {
                
                TextEditor(text: $text)
//                    .font(.sansRegular(size: 12))
                    .frame(height: height)
                    .colorMultiply(Color.black)
                    .keyboardType(.alphabet)
                    .accentColor(.white)
                    .cornerRadius(10)
                    .autocorrectionDisabled()
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .padding(10)
                    .font(.sansRegular(size: 14))
                    .background(Color.textfieldBackground.cornerRadius(10, corners: .allCorners))
                    .frame(height: height)
                
                if text.isEmpty {
                    Text(placeholder)
//                        .font(.sansRegular(size: 12))
                        .foregroundColor(.gray)
                        .padding(10)
                        .padding(.leading, 3) // to align textfield cursor with text
                        .font(.sansRegular(size: 14))
                }
            }
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .onDisappear {
            UITextView.appearance().backgroundColor = nil
        }
    }
}

struct CustomTextEditor_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextEditor(text: .constant("Please enter description Please enter description Please enter descriptionPlease enter description Please enter description Please enter description"), placeholder: "Please enter description", height: 300)
    }
}
