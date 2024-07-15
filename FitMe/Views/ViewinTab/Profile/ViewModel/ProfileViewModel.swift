//
//  ProfileViewModel.swift
//  FitMe
//
//  Created by Ali Syed on 06/12/2023.
//

import Foundation
import SwiftData

class ProfileViewModel : FitMeBaseViewModel{
    @Published var name = ""
    @Published var base64Image = ""
    @Published var age = ""
    
    @Published var email = ""
    @Published var newEmail = ""
    @Published var otp = ""
    
    @Published var passwod = ""
    @Published var newPassword = ""
    @Published var reTypePassword = ""
    
    @Published var dietPreferencesIds = [""]
    @Published var foodDislikes = [""]
    
    @Published var imageURL = ""
    @Published var height = ""
    @Published var weight = ""
    @Published var userDetails: UserDetails?

}
extension ProfileViewModel : NetworkManagerService{
    @MainActor func updateProfilePicture() async {
        
        self.showLoader = true
        let endPoint : ProfileEndPoints = .editProfilePic(profile_pic: self.base64Image)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
//                self.userDetails = data.data ?? UserDetails()
//                UserDefaultManager.shared.set(user: userDetails)
//                self.imageURL = data.data?.profilePic ?? ""
                showError(message: "Profile updated successfully!")
                isSuccess = true
            }else{
                showError(message: data.message!)
            }
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func editProfile() async {
        
        self.showLoader = true
        let endPoint : ProfileEndPoints = .editProfile(name: self.name, age: self.age, height: self.height, weight: self.weight)
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
                showError(message: "Profile updated successfully!")
                self.isSuccess = true
            }else{
                showError(message: data.message!)
            }
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func getProfileDetails() async {
        
        self.showLoader = true
        let endPoint : ProfileEndPoints = .getProfileDetails
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            self.userDetails = data.data
            UserDefaultManager.shared.set(user: userDetails)
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
    }
    
    
    @MainActor func updateFoodPreference() async {
        
        self.showLoader = true
        let endPoint : ProfileEndPoints = .updateFoodPreference(food_preferenceIds: self.dietPreferencesIds, food_dislikes: self.foodDislikes)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                showError(message: "Food Preferences updated!")
                UserDefaultManager.shared.set(user: userDetails)
                self.isSuccess = true
            }
            
        case .failure(let error):
            debugPrint(error.localizedDescription)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func generateOTP(email : String, type : Int) async {
        
        self.showLoader = true
        let endPoint : ProfileEndPoints = .generateOTP(email: email, type: type)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GenericResponse>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            showError(message: data.message!)
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func verifyOTP(email: String, type: Int, completion: @escaping () -> Void) async {
        
        self.showLoader = true
        let endPoint : ProfileEndPoints = .verifyOTP(email: email, otp: self.otp, type: type)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                
                completion()
                if type == 2{
                    self.userDetails = data.data
                    UserDefaultManager.shared.set(user: data.data)
                }
            }
            showError(message: data.message!)
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func updateEmail() async {
        
        self.showLoader = true
        let endPoint : ProfileEndPoints = .updateEmail(email: self.newEmail)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GenericResponse>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                showError(message: "Email updated successfully!")
                self.isSuccess = true
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func updatePassword() async {
        
        self.showLoader = true
        let endPoint : ProfileEndPoints = .updatePassword(old_password: self.passwod, new_password: self.newPassword)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GenericResponse>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                showError(message: "Password updated successfully!")
                self.passwod = ""
                self.newPassword = ""
                self.reTypePassword = ""
                self.isSuccess = true
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    @MainActor func deleteAccount(completion : @escaping () -> Void) async {
        
        self.showLoader = true
        let endPoint : ProfileEndPoints = .deleteAccount
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GenericResponse>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                UserDefaultManager.shared.removeUser()
                completion()
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    func logout(modelContext: ModelContext) {

        UserDefaultManager.shared.removeUser()
        deleteShoppingListData(modelContext: modelContext)
        
    }
    
    func deleteShoppingListData(modelContext: ModelContext)  {
        do {
            try modelContext.delete(model: ShoppingItem.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
extension ProfileViewModel{
    func isOTPEntered() -> Bool{
        if self.otp.isEmpty{
            showError(message: "Please Enter the OTP!")
            return false
        }
        return true
    }
    
    func isResetPasswordDataValid() -> Bool{
        
        if self.newPassword != self.reTypePassword{
            showError(message: "Password does not match!")
            return false
        }
        if !isValidPassword(self.newPassword){
            showError(message: "Password must contain atleast 8 characters and one special character!")
            return false
        }
        return true
    }
    
    func isEditProfileDataValid() -> Bool{
        if self.name.isEmpty {
            showError(message: "Name field cannot be empty!")
            return false
        }
        return true
    }

}
