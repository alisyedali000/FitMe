//
//  GoogleSignIn.swift
//  FitMe
//
//  Created by Ali Syed on 04/12/2023.
//


import Firebase
import GoogleSignIn
import SwiftUI

class GoogleAuth: ObservableObject {
    @Published var state: SignInState = .signedOut
    @Published var authVM : AuthViewModel
    
    init(authVM: AuthViewModel? = nil) {
        self.authVM = authVM ?? AuthViewModel()
    }
    
    enum SignInState {
        case signedIn
        case signedOut
    }
}
extension GoogleAuth{
    func signIn(completion: @escaping () -> Void) {
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            
            let configuration = GIDConfiguration(clientID: clientID)
            
            
            guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
            
            
            GIDSignIn.sharedInstance.signIn(with: configuration, presenting: presentingViewController) { user, error in
                self.authenticateUser(for: user, with: error)
                completion()
                
            }
        }
    }
    
//    func signUpWithEmail(userEmail: String, userPassword:String) async -> (AuthDataResult?)  {
//        
//        await withCheckedContinuation { continuation in
//            
//            Auth.auth().createUser(withEmail: userEmail, password: userPassword){ authResult, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                if let results = authResult{
//                    self.firebaseID = results.user.uid
//                }
//                continuation.resume(returning: (authResult))
//            }
//            
//        }
//        
//        
//        
//    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        
        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
        
        
        Auth.auth().signIn(with: credential) { authResult, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                self.setUserData(authResult: authResult!)
            }
            
        }
    }
    
    
    func signOut() {
        
        GIDSignIn.sharedInstance.signOut()
        
        do {
            
            try Auth.auth().signOut()
            
            state = .signedOut
            //        UserDefaultManager.Authenticated.send(false)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteUser(){
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User successfully deleted from firebase")
            }
        }
        
        
    }
    
    
    
    func setUserData(authResult: AuthDataResult){

        self.authVM.email = authResult.user.email ?? ""
        self.authVM.name = authResult.user.displayName ?? ""
        self.authVM.socialKey = "google"
        self.authVM.socialToken = authResult.user.uid
        self.authVM.deviceID = ""
        Task{
            await authVM.socialLogin(){
                UserDefaultManager.shared.setSocialLogin(true)
            }
        }
        
        
    }
        
}
