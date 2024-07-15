//
//  GsignInViewModel.swift
//  BattleRap
//
//  Created by Qazi Ammar Arshad on 18/03/2022.
//

import Foundation
//import GoogleSignIn

//@MainActor final class GSignInViewModel: Authenticator {
//    
//    @Published var errorMessage: String = ""
//    @Published var showError: Bool = false
//    
//    private let firstLogin: (Bool) -> Void //= {_ in}
//    
//    private let showLoader: (Bool) -> Void
//    
//    init(firstLogin: @escaping (Bool) -> Void, showLoader: @escaping (Bool) -> Void) {
//        self.firstLogin = firstLogin
//        self.showLoader = showLoader
//    }
//    
////    func checkStatus(){
////        if(GIDSignIn.sharedInstance.currentUser != nil) {
////            let user = GIDSignIn.sharedInstance.currentUser
////            //            Helper.shared.printDebug(user)
////            guard let user = user else { return }
////            
////            debugPrint(user)
////            
////        } else {
////            
////            debugPrint("Not Logged In")
////        }
////    }
//    
//    func signIn() {
////        
////        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
////        
////        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
////        // Create Google Sign In configuration object.
////        let config = GIDConfiguration(clientID: clientID)
////        
////        // Start the sign in flow!
////        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingViewController) { user, error in
////            
////            if let anyError = error {
////                
////                print(anyError.localizedDescription)
////                self.showLoader(false)
////                return
////            }
////            
////            self.checkStatus()
////        }
//    }
//    
//    func signOut(){
////        GIDSignIn.sharedInstance.signOut()
////        self.checkStatus()
//    }
//    
//    func typeName() -> String {
//        "Login with Google"
//    }
//    
//    func typeImage() -> String {
//        "google"
//    }
//}
