//
//  LoginView.swift
//  FitMe
//
//  Created by Taimoor Arif on 20/11/2023.
//

import SwiftUI

struct LoginView: FitMeBaseView {
    @StateObject var authVM =  AuthViewModel()
    @StateObject var googleAuth =  GoogleAuth()
    @StateObject var appleAuth = AppleSignIn()
    
    @State var moveToForgot = false
    
    private struct Config {
        
        static let topDescription = "Get your meal plan ready for the week! Login to your FitMe account!"
        static let emailPlaceholder = "Email"
        static let passwordPlaceholder = "Password"
        
        static let forgotPassword = "Forgot Password?"
        static let loginBtnTitle = "Login"
        
        static let dontHaveAccount = "Don't have an account?"
        static let signUp = "Sign Up"
    }
    @State var weight = 23.0
    var body: some View {
        ZStack{
            loadView()

                .alert("FitMe", isPresented: $authVM.showError) {
                } message: {
                    Text(authVM.errorMessage)
                }
            LoaderView(isLoading: $authVM.showLoader)
        }
        .navigationDestination(isPresented: $authVM.moveToDetailsPage) {
            SignUpAndDetailsView(googleAuth: googleAuth, appleAuth: appleAuth, authVM: authVM, pageSelection: 2).navigationBarBackButtonHidden()
        }

        .navigationDestination(isPresented: $moveToForgot) {
            ForgotPasswordView(moveBack: $moveToForgot)
        }
    }
}

extension LoginView {
    
    func loadView() -> some View {
        
        VStack(spacing: 25) {
            
            VStack {
                
                AppLogo()
                
                Text(Config.topDescription).description()
            }
            ScrollView(showsIndicators: false){
                VStack(spacing: 20) {
                    
                    VStack(spacing: 15) {
                        
                        textfields()
                        
                        forgotPassword
                        Button{
                            if authVM.isLoginDataValid(){
                                Task{
                                    await authVM.login()
                                    
                                }
                            }
                        }label: {
                            RedButton(title: Config.loginBtnTitle)
                        }
                        
                    }
                    
                    orView
                    
                    socialSignups()
                    
                    dontHaveAccount
                    
                }
            }
            
        }
        .padding(.horizontal)
    }
}

extension LoginView {
    

    
    func textfields() -> some View {
        
        VStack(spacing: 20) {
          
            CustomTextField(placeholder: Config.emailPlaceholder, image: ImageName.email, text: $authVM.email)
            
            PasswordTextField(placeHolder: Config.passwordPlaceholder, image: ImageName.eye, text: $authVM.password)
        }
    }
    
    var forgotPassword: some View {
        
        HStack {
         
            Spacer()
            
            Button {
                self.moveToForgot = true
            } label: {
                
                Text(Config.forgotPassword)
                    .font(.sansRegular(size: 12))
                    .foregroundStyle(Color.redColor)
            }
        }
    }
    
    var orView: some View {
        
        HStack {
            
            ImageName.leftLine
                .resizable()
                .scaledToFit()
                .frame(height: 2)
            
            Text("OR")
                .foregroundStyle(.black)
                .font(.sansRegular(size: 12))
            
            ImageName.rightLine
                .resizable()
                .scaledToFit()
                .frame(height: 2)
        }
    }
    
    func socialSignups() -> some View {
        
        VStack(spacing: 20, content: {
            
            /// google sign in
            SocialButtons(image: ImageName.google, title: "Login with Google") {
                googleAuth.signIn {
                
                }
            }
            SocialButtons(image: ImageName.apple, title: "Login with Apple") {
                appleAuth.signIn()
            }
        })
    }
    
    var dontHaveAccount: some View {
        
        HStack {
            
            Text(Config.dontHaveAccount)
                .foregroundStyle(.black)
                .font(.sansRegular(size: 14))
            
            NavigationLink {
                SignUpAndDetailsView(googleAuth: googleAuth, appleAuth: appleAuth, authVM: authVM, pageSelection: 1).navigationBarBackButtonHidden()
            } label: {
                
                Text(Config.signUp)
                    .foregroundStyle(Color.redColor)
                    .font(.sansMedium(size: 14))
            }
        }
    }
}

#Preview {
    LoginView()
}
