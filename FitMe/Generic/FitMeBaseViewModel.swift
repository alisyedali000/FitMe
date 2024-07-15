//
//  FitMeBaseViewModel.swift
//  FitMe
//
//  Created by Ali Syed on 30/11/2023.
//

import Foundation
import SwiftUI

class FitMeBaseViewModel: ObservableObject {
    @Published var showLoader = false
    @Published var showError = false
    @Published var isSuccess = false
    var errorMessage = ""
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        if !emailPred.evaluate(with: email) {
            showError(message: "Please Enter a valid Email")
            return false
        }
        return true
            
        
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?])(?=.{8,}$).*$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }


    
    func showError(message: String) {
        errorMessage = message
        showError = true
    }
 
}
