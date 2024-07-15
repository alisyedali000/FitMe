//
//  ChangeEmailVIew.swift
//  FitMe
//
//  Created by Ali Syed on 06/12/2023.
//

import SwiftUI

struct ChangeEmailView: View {
    @Environment (\.presentationMode) var presentationMode
    @StateObject var profileVM : ProfileViewModel
    @State var isOldEmailVerfied = false
    var body: some View {
        ZStack{
            VStack{
                if isOldEmailVerfied{
                    newEmailScreen()
                }else{
                    oldEmailScreen()
                }
                
            }
            LoaderView(isLoading: $profileVM.showLoader)
                .alert("FitMe", isPresented: $profileVM.showError) {
                    
                } message: {
                    Text(profileVM.errorMessage)
                }

        }.navigationTitle("Change Email").toolbarRole(.editor)
    }
}
extension ChangeEmailView{
    func oldEmailScreen() -> some View{
        VStack{
            HStack{
                Text("Just enter your Email Address so can we can send you a verification code to continue.")
                    .font(.sansRegular(size: 12))
                    .foregroundColor(.grayImages)
                Spacer()
            }
            CustomTextField(placeholder: "Old Email Address", image: ImageName.email, text: $profileVM.email)
            HStack{
                Spacer()
                Button{
                    if profileVM.isValidEmail(email: profileVM.email){
                        Task{
                            await profileVM.generateOTP(email: profileVM.email, type: 1)
                        }
                    }
                }label: {
                    Text("Send OTP")
                        .foregroundColor(.redColor)
                        .font(.sansRegular(size: 12))
                }
          
            }
            OTP_Fields(OTPText: $profileVM.otp)
            Spacer()
            Button{
                if profileVM.isOTPEntered(){
                    Task{
                        await profileVM.verifyOTP(email: profileVM.email, type: 1){
                            withAnimation {
                                self.isOldEmailVerfied = true
                            }
                            profileVM.otp = ""
                        }
                      
                    }
                }
            }label: {
                RedButton(title: "Verify")
            }
            
            
            
        }.padding(.horizontal)
    }
    
    func newEmailScreen() -> some View{
        VStack{
            HStack{
                Text("Enter your new email address so you can change your email.")
                    .font(.sansRegular(size: 12))
                    .foregroundColor(.grayImages)
                Spacer()
            }
            CustomTextField(placeholder: "New Email Address", image: ImageName.email, text: $profileVM.newEmail)
            HStack{
                Spacer()
                Button{
                    if profileVM.isValidEmail(email: profileVM.newEmail){
                        Task{
                            await profileVM.generateOTP(email: profileVM.newEmail, type: 2)
                        }
                    }
                }label: {
                    Text("Send OTP")
                        .foregroundColor(.redColor)
                        .font(.sansRegular(size: 12))
                }
            }
            OTP_Fields(OTPText: $profileVM.otp)
            Spacer()
            Button{
                Task {
                    if profileVM.isOTPEntered(){
                        Task{
                            await profileVM.verifyOTP(email : profileVM.newEmail, type: 2){
                                profileVM.otp = ""
                                self.presentationMode.wrappedValue.dismiss()
                            }
                          
                        }
                    }
                }
            }label: {
                RedButton(title: "Verify")
            }
            
            
            
        }.padding(.horizontal)
    }
}
#Preview {
    ChangeEmailView(profileVM: ProfileViewModel())
}
