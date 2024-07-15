//
//  SocialButtons.swift
//  FitMe
//
//  Created by Ali Syed on 30/11/2023.
//
import SwiftUI
struct SocialButtons: View {
   
        var image : Image
        var title : String
        var action : () -> Void
    
    var body: some View {
       
        Button(action: action) {
            HStack{
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color .textfieldBackground, lineWidth: 1.5)
                            .shadow(color: .textfieldBackground, radius: 15)
                            .overlay(
                                HStack {
                                     image
                                        
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24)
                                        .padding(.leading,30)
                                    Spacer()
                                    Text(title)
                                        .font(.sansRegular(size: 17))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                            )
                            
                    )
            }
        }
    }
    
}

struct SocialButtons_Previews: PreviewProvider {
    static var previews: some View {
        SocialButtons(image: ImageName.google, title: "Login With Google", action: {})
    }
}
