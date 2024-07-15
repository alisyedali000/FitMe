//
//  GSignInButton.swift
//  BattleRap
//
//  Created by Qazi Ammar Arshad on 07/03/2022.
//

import SwiftUI

//struct SignInButton<T>: View where T: Authenticator {
//    
//    @Binding var errorMessage: String
//    @Binding var showError: Bool
//    @ObservedObject var vm: T
//    
//    var body: some View {
//        
//        Button {
//            
//            vm.signIn()
//            
//        } label: {
//            
//            ZStack {
//                RoundedRectangle(cornerRadius: 12)
//                    .foregroundColor(.white)
//                    .frame(height: 52)
//                    .shadow(radius: 0.5)
//                
//                ZStack {
//                    
//                    HStack(spacing: 5) {
//                        
//                        let isAppleImage: Bool = vm.typeImage() == "apple" ? true : false
//                        
//                        isAppleImage ?
//                        
//                        AnyView(
//                            Image(systemName: "apple.logo")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 24, height: 30)
//                                .foregroundStyle(.black)
//                        ) :
//                        
//                        AnyView(
//                            ImageName.google
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 24, height: 24)
//                        )
//                        
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    
//                    Text(vm.typeName())
//                        .foregroundColor(.black)
//                        .font(.sansRegular(size: 17))
//                }
//            }
//        }
//        
//        .onAppear {
//            errorMessage = vm.errorMessage
//            showError = vm.showError
//        }
//    }
//}
//
//struct GSignInButton_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        SignInButton(errorMessage: .constant("GSign In error"), showError: .constant(false), vm: Mock())
//    }
//}
//
//class Mock: Authenticator {
//    
//    var errorMessage: String = ""
//    
//    var showError: Bool = true
//    
//    func typeName() -> String {
//        "Login with Google"
//    }
//    
//    func typeImage() -> String {
//        "apple"
//    }
//    
//    func signIn() {
//        
//    }
//    
//}
