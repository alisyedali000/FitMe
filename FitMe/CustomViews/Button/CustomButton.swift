//
//  CustomButton.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 21/12/2023.
//

import SwiftUI

struct CustomButton: FitMeBaseView {

    var title: String
    var makeStrokButton = false
    var action: () -> (Void)
    
    
    var body: some View {
        loadView
    }
}

// MAKR: View Extesnion
extension CustomButton {
    
    var loadView: some View {
        Button(action: {
            action()
        }, label: {
            
            if makeStrokButton {
             strokeButton
            } else {
                borderedButton
            }
        })
    }
    
    
    var strokeButton: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .stroke(primaryColor, lineWidth: 1.0)
                .frame(height: 46)
                
            Text(title)
                .foregroundStyle(primaryColor)
                .font(.sansMedium(size: 16))
                
        }
    }
    
    var borderedButton: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 46)
            Text(title)
                .foregroundStyle(.white)
                .font(.sansMedium(size: 16))
        }
    }
    
}


#Preview {
    CustomButton(title: "Add to meal plan", makeStrokButton: true) {
        
    }
}
