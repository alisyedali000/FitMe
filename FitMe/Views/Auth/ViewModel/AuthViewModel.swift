//
//  AuthEndPoints.swift
//  FitMe
//
//  Created by Ali Syed on 01/12/2023.
//

import Foundation

class AuthViewModel : FitMeBaseViewModel {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var newPassword = ""
    @Published var gender = ""
    @Published var age = ""
    @Published var height = ""
    @Published var weight = ""
    @Published var dietPreferenceIds = [""]
    @Published var foodDislikes = [""]
    @Published var userDetails: UserDetails?
    
    @Published var confirmPassword = ""
    @Published var otp = ""
    
    @Published var socialKey = ""
    @Published var socialToken = ""
    @Published var deviceID = ""
    @Published var moveToHome = false
    @Published var moveToDetailsPage = false
    @Published var moveToResetPassword = false
    
    @Published var imageURL = ""
    
    var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 0
        return f
    }
}


extension AuthViewModel:NetworkManagerService {
    
    @MainActor func register(completion: @escaping () -> Void) async {
        
        self.showLoader = true
        let endPoint : AuthEndPoints = .register(name: self.name, email: self.email, password: self.password, gender: self.gender, age: "\(self.age)", height: self.height, weight: self.weight, foodPreferenceIds: self.dietPreferenceIds, foodDislikes: self.foodDislikes)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                self.userDetails = data.data
                UserDefaultManager.shared.set(user: userDetails)
                UserDefaultManager.shared.setSplashShownStatus()
                UserDefaultManager.Authenticated.send(true)
                UserDefaultManager.shared.setSocialLogin(false)
                completion()
            }else{
                showError(message: data.message!)
            }
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func login() async {
        
        self.showLoader = true
        let endPoint : AuthEndPoints = .login(email: self.email, password: self.password)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                self.userDetails = data.data
                self.moveToHome = true
                UserDefaultManager.shared.set(user: userDetails)
                UserDefaultManager.shared.setSplashShownStatus()
                UserDefaultManager.Authenticated.send(true)
                UserDefaultManager.shared.setSocialLogin(false)
                
            }else{
                showError(message: data.message!)
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func socialLogin(completion: @escaping () -> Void) async {
        
        self.showLoader = true
        let endPoint : AuthEndPoints = .socialLogin(social_key: self.socialKey, social_token: self.socialToken, email: self.email, name: self.name, device_id: "21312123")
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            self.userDetails = data.data
            if let user = data.data {
                //                self.moveToHome = true
                UserDefaultManager.shared.set(user: user)
                UserDefaultManager.Authenticated.send(true)
                UserDefaultManager.shared.setSocialLogin(true)
                UserDefaultManager.shared.setSplashShownStatus()
                completion()
            }else{
                self.moveToDetailsPage = true
            }
            UserDefaultManager.shared.setSocialLogin(true)
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func socialEditProfile(completion: @escaping () -> Void) async {
        
        self.showLoader = true
        let endPoint : AuthEndPoints = .editSocialProfile(user_id: "\(String(describing: self.userDetails?.id))", gender: self.gender, age: self.age, height: self.height, weight: self.weight, food_preferenceIDs: self.dietPreferenceIds, food_dislikes: self.foodDislikes)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                self.userDetails = data.data
                
                //            self.moveToHome = true
                UserDefaultManager.shared.setSplashShownStatus()
                UserDefaultManager.shared.set(user: userDetails)
                UserDefaultManager.Authenticated.send(true)
                UserDefaultManager.shared.setSocialLogin(true)
                completion()
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func generateOTP() async {
        
        self.showLoader = true
        let endPoint : AuthEndPoints = .generateOTP(email: self.email)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GenericResponse>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                //                moveToResetPassword = true
                showError(message: "An OTP has been sent successfully!")
            }else{
                showError(message: data.message!)
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func verifyOTP() async {
        
        self.showLoader = true
        let endPoint : AuthEndPoints = .verifyOTP(email: self.email, otp: self.otp)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                moveToResetPassword = true
            }else{
                showError(message: data.message!)
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func resetPassword() async {
        
        self.showLoader = true
        let endPoint : AuthEndPoints = .resetPassword(email: self.email, password: self.password)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GenericResponse>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                showError(message: "Password updated successfully!")
                self.isSuccess = true

            }else{
                showError(message: data.message!)
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    
    
}

extension AuthViewModel{
    func isLoginDataValid() -> Bool{

        if isValidEmail(email: self.email){
            if isValidPassword(self.password){
                return true
            }
            showError(message: "Password must be 8 characters long and must include a special character!")
            return false
        }
        //        showError(message: "Please Enter a valid Email Address!")
        return false
    }
    
    func isSignUpDataValid() -> Bool{
        if self.name.isEmpty{
            showError(message: "Please Enter your name!")
            return false
        }
        if !isValidEmail(email: self.email){
            showError(message: "Please Enter a valid Email Address!")
            return false
        }
        if !UserDefaultManager.shared.isSocialLogin(){
            if self.password != self.confirmPassword{
                showError(message: "Password does not match!")
                return false
            }
            
            if !isValidPassword(self.password){
                showError(message: "Password must be 8 characters long and must include a special character!")
                return false
            }
        }
        return true
    }
    
    func isUserDetailsValid() -> Bool{
        if self.gender.isEmpty{
            showError(message: "Please select your gender!")
            return false
        }
        if self.age.isEmpty{
            showError(message: "Please enter your Age!")
            return false
        }
        if self.height == ""{
            showError(message: "Height is not Valid!")
            return false
        }
        if self.weight == ""{
            showError(message: "Weight is not Valid!")
            return false
        }
        
        return true
    }
    
    func isDietPreferenceValid() -> Bool {
        if self.foodDislikes.isEmpty{
            showError(message: "Please Select atleast one Disliked Food!")
            return false
        }
        return true
    }
    
    func isResetPasswordDataValid() -> Bool{
        if !isValidPassword(self.password){
            showError(message: "Password must contain minimum 8 characters and one special character!")
            return false
        }
        if self.password != self.confirmPassword{
            showError(message: "Password does not match!")
            return false
        }
        return true
    }
    
    func isOTPEntered() -> Bool{
        if self.otp.count < 4{
            showError(message: "Please Enter the OTP!")
            return false
        }
        return true
    }
    
}

extension AuthViewModel{
    func clearFields(){
        self.name = ""
        self.email = ""
        self.password = ""
        self.newPassword = ""
        self.gender = ""
        self.age = ""
        self.height = ""
        self.weight = ""
        self.foodDislikes = [""]
        
        self.confirmPassword = ""
        self.otp = ""
        self.isSuccess = false
        self.socialKey = ""
        self.socialToken = ""
        self.deviceID = ""
        self.moveToHome = false
        self.moveToDetailsPage = false
        self.moveToResetPassword = false
        
    }
}
