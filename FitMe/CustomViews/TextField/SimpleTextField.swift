//
//  SimpleTextField.swift
//  FitMe
//
//  Created by Ali Syed on 07/12/2023.
//

import SwiftUI





struct SimpleTextField: View {
    var placeholder : String
    @Binding var value : String
    
    var body: some View {
        VStack(alignment: .leading,spacing: 10){
            TextField(placeholder, text: $value)
                .font(.sansRegular(size: 14))
                .padding()
                .padding(.trailing,25)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.textfieldBackground)
                        
                    
                )
                

            
        }
    }
}

#Preview {
    SimpleTextField(placeholder: "", value: .constant(""))
}
