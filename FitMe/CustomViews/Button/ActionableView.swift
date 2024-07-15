//
//  ActionableView.swift
//  Koy
//
//  Created by Taimoor Arif on 04/10/2023.
//

import SwiftUI

struct ActionableView: View {
    
    private var title: String
    private var image: Image
    private var action: () -> Void
    
    init(title: String, image: Image, action: @escaping () -> Void) {
        self.title = title
        self.image = image
        self.action = action
    }
    
    var body: some View {
        
        
        
        Button(action: {
            self.action()
        }, label: {
            
            ZStack(alignment: .trailing) {
                
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: 50)
//                    .foregroundStyle(Color.textFieldBackground)
                
                HStack {
                    Text(title)
//                        .font(.sansRegular(size: 12))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    self.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .padding(.horizontal)
            }
        })
    }
}

#Preview {
    ActionableView(title: "Desigining", image: Image(""), action: {})
}
