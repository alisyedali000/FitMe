//
//  ChangePasswordView.swift
//  FitMe
//
//  Created by Ali Syed on 07/12/2023.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment (\.dismiss) var dismiss
    @StateObject var profileVM : ProfileViewModel
    var body: some View {
        ZStack{
            VStack(spacing : 20){
                HStack{
                    Text("Enter your new password it must be different from previously used password")
                        .font(.sansRegular(size: 12))
                        .foregroundColor(.grayImages)
                    Spacer()
                }
                PasswordTextField(placeHolder: "Old Password", image: ImageName.eye, text: $profileVM.passwod)
                
                PasswordTextField(placeHolder: "New Password", image: ImageName.eye, text: $profileVM.newPassword)
                
                PasswordTextField(placeHolder: "Re-Type New Password", image: ImageName.eye, text: $profileVM.reTypePassword)
                
                Spacer()
                
                Button{
                    if profileVM.isResetPasswordDataValid(){
                        Task{
                            await profileVM.updatePassword()
                        }
                    }
                }label: {
                    RedButton(title: "Done")
                }
                
            }.padding(.horizontal)
            LoaderView(isLoading: $profileVM.showLoader)
        }.navigationTitle("Change Password").toolbarRole(.editor).alert("FitMe", isPresented: $profileVM.showError) {
            Button("OK"){
                if profileVM.isSuccess{
                    profileVM.isSuccess = false
                    self.dismiss()
                }
            }
        } message: {
            Text(profileVM.errorMessage)
        }

    }
}

#Preview {
    ChangePasswordView(profileVM: ProfileViewModel())
}
