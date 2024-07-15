//
//  ResetPassword.swift
//  FitMe
//
//  Created by Ali Syed on 01/12/2023.
//

import SwiftUI

struct ResetPassword: View {
    @ObservedObject var authVM : AuthViewModel
    @Binding var moveBack: Bool
    
    var body: some View {
        ZStack{
            VStack(spacing: 20){
                Text("Enter your email address so can we can send you a verification code to continue")
                    .foregroundColor(.grayImages)
                    .font(.sansRegular(size: 12))
                PasswordTextField(placeHolder: "Password", image: ImageName.eye, text: $authVM.password)
                PasswordTextField(placeHolder: "Confirm Password", image: ImageName.eye, text: $authVM.confirmPassword)
                
                Spacer()
                Button{
                    if authVM.isResetPasswordDataValid(){
                        Task{
                            await authVM.resetPassword()
                        }
                    }
                }label: {
                    RedButton(title: "Submit")
                }
            }.padding(.horizontal)
            LoaderView(isLoading: $authVM.showLoader)
        }.navigationTitle("Reset Password").toolbarRole(.editor).alert("FitMe", isPresented: $authVM.showError) {
            Button{
                if self.authVM.isSuccess{
                    moveBack = false
                }
            }label: {
                Text("OK")
            }
        } message: {
            Text(authVM.errorMessage)
        }
//        .navigationDestination(isPresented: $authVM.isSuccess) {
//            LoginView().hideNavigationBar
//        }

    }
}

#Preview {
    ResetPassword(authVM: AuthViewModel(), moveBack: .constant(false))
}
