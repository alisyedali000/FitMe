//
//  Bars.swift
//  FitMe
//
//  Created by Ali Syed on 30/11/2023.
//

import SwiftUI

struct Bars: FitMeBaseView {
    @EnvironmentObject var authVM : AuthViewModel
    @Binding var selection : Int
    var body: some View {
        HStack{
            Rectangle()
                .frame(height: 5)
                .foregroundColor(selection == 1 ? primaryColor : textFieldColor)
                .cornerRadius(19)
                .onTapGesture {
                    withAnimation {
                        selection = 1
                    }
                }
            Spacer()
            Rectangle()
                .frame(height: 5)
                .foregroundColor(selection == 2 ? primaryColor : textFieldColor)
                .cornerRadius(19)
                .onTapGesture {
                    withAnimation {
                        if authVM.isSignUpDataValid(){
                            selection = 2
                        }
                    }
                }
            Spacer()
            Rectangle()
                .frame(height: 5)
                .foregroundColor(selection == 3 ? primaryColor : textFieldColor)
                .cornerRadius(19)
                .onTapGesture {
                    withAnimation {
                        if authVM.isUserDetailsValid(){
                            selection = 3
                        }
                    }
                    
                }
        }
    }
}

#Preview {
    Bars(selection: .constant(1))
}
