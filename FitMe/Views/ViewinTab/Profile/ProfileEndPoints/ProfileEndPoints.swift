//
//  ProfileEndPoints.swift
//  FitMe
//
//  Created by Ali Syed on 06/12/2023.
//


import Foundation
enum ProfileEndPoints {

    case editProfilePic(profile_pic: String)
    
    case editProfile(name:String,
                     age:String,
                     height: String,
                     weight: String)
    
    case updatePassword(old_password: String,
                        new_password: String)
    case deleteAccount
    
    case updateFoodPreference(food_preferenceIds: [String],
                              food_dislikes:[String])
    
    case generateOTP(email: String, type: Int)
    
    case verifyOTP(email: String, otp: String, type: Int)
    
    case updateEmail(email: String)

    
    case getProfileDetails
}
extension ProfileEndPoints : Endpoint {
    
    
    var path: String {
        switch self {
        case .editProfilePic :
            return "\(AppUrl.APIPATCH)/profile/profileImage"
            
        case .editProfile:
            return "\(AppUrl.APIPATCH)/profile/editProfile"
            
        case .updatePassword:
            return "\(AppUrl.APIPATCH)/profile/updatePassword"
            
        case .deleteAccount:
            return "\(AppUrl.APIPATCH)/profile/delete"
            
        case .updateFoodPreference:
            return "\(AppUrl.APIPATCH)/profile/updateFoodPreferenceorDislikes"
            
        case .generateOTP:
            return "\(AppUrl.APIPATCH)/profile/generateOTPForEmail"
            
        case .verifyOTP:
            return "\(AppUrl.APIPATCH)/profile/verifyOTPForEmail"
            
        case .updateEmail:
            return "\(AppUrl.APIPATCH)/profile/resetEmail"
            
        
            
        case .getProfileDetails:
            return "\(AppUrl.APIPATCH)/profile/myProfile"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .editProfilePic:
            return .put
            
        case .editProfile:
            return .put
            
        case .updatePassword:
            return .put
            
        case .updateFoodPreference:
            return .put
        
        case .generateOTP:
            return .post
            
        case .verifyOTP:
            return .post
            
        case .updateEmail:
            return .post
            
        case .deleteAccount:
            return .post
            
    
            
        case .getProfileDetails:
            return .post
        }
    }
    
    var body: [String : Any?]? {
        switch self {
        case .updateEmail(let email):
            let params = ["user_id": user_id,
                          "email" : email]
            return params
            
        case .generateOTP(let email, let type):
            let params = ["user_id" : "\(UserDefaultManager.shared.get()?.id ?? 0)",
                          "email" : email,
                          "type": type] as [String : Any]
            return params
            
        case .verifyOTP(let email, let otp, let type):
            let params = ["email": email,
                          "otp": otp,
                          "user_id": "\(UserDefaultManager.shared.get()?.id ?? 0)",
                          "type" : type] as [String : Any]
            return params
            
        case .updatePassword(let old_password, let new_password):
            let params = ["user_id": user_id,
                          "old_password": old_password,
                          "new_password" : new_password]
            return params
            
        case .editProfilePic(let profile_pic):
            let params = ["user_id":user_id,
                          "profile_pic":profile_pic]
            return params
            
        case .editProfile(let name,
                          let age,
                          let height,
                          let weight):
            let params = ["user_id": user_id,
                          "name": name,
                          "age" : age,
                          "height":height,
                          "weight":weight]
            return params
            
        case .deleteAccount:
            let params = ["user_id" : user_id]
                return params
            
        case .updateFoodPreference(let food_preference, let food_dislikes):
            let params = ["user_id": user_id,
                          "food_preference" : food_preference,
                          "food_dislikes": food_dislikes] as [String : Any]
            return params

            
        case .getProfileDetails:
            let params = ["user_id" : user_id]
            return params
        }
    }
    
    
}


