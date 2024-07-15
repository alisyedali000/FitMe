//
//  ForgotPasswordView.swift
//  FitMe
//
//  Created by Ali Syed on 01/12/2023.
//

import SwiftUI

struct ForgotPasswordView: View {
    @StateObject var authVM = AuthViewModel()
    
    @Binding var moveBack: Bool
    
    var body: some View {
        ZStack{
            VStack{
                Text("Enter your email address so can we can send you a verification code to continue")
                    .foregroundColor(.grayImages)
                    .font(.sansRegular(size: 12))
                
                CustomTextField(placeholder: "Email Address", image: ImageName.email, text: $authVM.email)
                HStack{
                    Spacer()
                    Button{
                        if authVM.isValidEmail(email: authVM.email){
                            Task{
                                await authVM.generateOTP()
                            }
                        }
                    }label: {
                        Text("Send OTP")
                            .font(.sansRegular(size: 12))
                    }
                }
                
                OTP_Fields(OTPText: $authVM.otp)
                Spacer()
                Button{
                    if authVM.isOTPEntered(){
                        Task{
                            await authVM.verifyOTP()
                        }
                    }
                }label: {
                    RedButton(title: "Continue")
                }
            }.padding(.horizontal)
                .addDoneButton
                .alert("FitMe", isPresented: $authVM.showError) {
                } message: {
                    Text(authVM.errorMessage)
                }
            LoaderView(isLoading: $authVM.showLoader)
                .navigationDestination(isPresented: $authVM.moveToResetPassword) {
                    ResetPassword(authVM: self.authVM, moveBack: $moveBack)
                }
        }.navigationTitle("Forgot Password").toolbarRole(.editor)
    }
}

#Preview {
    ForgotPasswordView(moveBack: .constant(false))
}
