//
//  GreenButton.swift
//  Koy
//
//  Created by Taimoor Arif on 01/09/2023.
//

import SwiftUI

struct RedButton: View {
    
    private var title: String
//    private var action : () -> Void
    
    init(title: String) {
        self.title = title
//        self.action = action
    }
    
    var body: some View {
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.redColor)
                    .frame(height: 56)
                
                Text(title)
                    .foregroundColor(.white)
                    .font(.sansMedium(size: 18))
            }
    }
}

struct CancelButton: View {
    
    var title: String
    var action : () -> (Void)
    
    
    var body: some View {
        
        Button(action: {
            action()
        }, label: {
            ZStack {
                
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(Color.textfieldBackground)
                    .frame(height: 46)
                
                Text(title)
                    .foregroundColor(.grayImages)
                    .font(.sansRegular(size: 16))
            }
        })
           
    }
}

struct CancelButton_Previews: PreviewProvider {
    static var previews: some View {
        CancelButton(title: "Cancel", action: {
            
        })
    }
}
