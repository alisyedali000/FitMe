//
//  AppleSignIn.swift
//  FitMe
//
//  Created by Ali Syed on 04/12/2023.
//

import Foundation
import SwiftUI
import CryptoKit
import Firebase
import AuthenticationServices

class AppleSignIn: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private var currentNonce: String?
    @Published var authVM : AuthViewModel
    
    init(authVM: AuthViewModel? = nil) {
        self.authVM = authVM ?? AuthViewModel()
    }
    
    
    func signIn() {
        currentNonce = randomNonceString()
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(currentNonce!)

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("Successfully signed out")
//            self.state = .signedOut
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let fullName = appleIDCredential.fullName?.givenName
            let email = appleIDCredential.email
            let token = appleIDCredential.user
            let userIdentifier = appleIDCredential.user
            debugPrint("User id is \(token) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            getCredentialState(userID: userIdentifier)
            
                            /// Signing in with Firebase
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)

        
            
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase sign-in error: \(error.localizedDescription)")
                } else {
                    print("Successfully signed in with Apple and Firebase.")
                    self.setUserData(authResult: authResult!)
                 
             
                }
            }
            
            
            
            
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple error: \(error.localizedDescription)")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        while result.count < length {
            let randomBytes: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randomBytes.forEach {
                if result.count < length {
                    let value = $0
                    if value < charset.count {
                        result.append(charset[Int(value)])
                    }
                }
            }
        }
        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}


extension AppleSignIn{
    enum SignInState {
          case signedIn
          case signedOut
      }
    enum UserType{
        case company
        case user
    }
    
    

    
    func setUserData(authResult: AuthDataResult){
        
//        let firebaseUserID = authResult.user.uid
//        let firebaseEmail = authResult.user.email
//        let firebaseUserName = authResult.user.displayName
     
            
        self.authVM.email = authResult.user.email ?? ""
        self.authVM.name = authResult.user.displayName ?? "Username"
        self.authVM.socialKey = "apple"
        self.authVM.socialToken = authResult.user.uid
            
        Task {
            await self.authVM.socialLogin(){
                UserDefaultManager.shared.setSocialLogin(true)
            }
        }
        

        
    }
    
    
        func getCredentialState(userID: String) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: userID) { credentialState, _ in
                switch credentialState {
                case .authorized:
    
    
                    break
                case .revoked:
//                    self.state = .signedOut
                    break
                case .notFound:
    
                    break
                default:
                    break
                }
            }
        }
    
}
    


