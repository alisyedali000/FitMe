//
//  AuthEndPoints.swift
//  FitMe
//
//  Created by Ali Syed on 01/12/2023.
//

import Foundation
enum AuthEndPoints {
    case register(name: String,
                  email: String,
                  password: String,
                  gender: String,
                  age: String,
                  height: String,
                  weight: String,
                  foodPreferenceIds: [String],
                  foodDislikes: [String])
    case login(email : String, password: String)
    
    case socialLogin(social_key : String,
                     social_token : String,
                     email : String,
                     name: String,
                     device_id: String)
    
    case editSocialProfile(user_id : String,
                           gender : String,
                           age: String,
                           height: String,
                           weight: String,
                           food_preferenceIDs: [String],
                           food_dislikes: [String])
    
    case generateOTP(email: String)
    case verifyOTP(email: String, otp: String)
    case resetPassword(email: String, password: String)
}
extension AuthEndPoints : Endpoint {
    
    
    var path: String {
        switch self {
        case .register :
            return "\(AppUrl.APIPATCH)/register"
            
        case .login:
            return "\(AppUrl.APIPATCH)/login"
            
        case .socialLogin:
            return "\(AppUrl.APIPATCH)/socialLoginSignUp"
            
        case .editSocialProfile:
            return "\(AppUrl.APIPATCH)/editSocialProfile"
            
        case .generateOTP:
            return "\(AppUrl.APIPATCH)/generateOTP"
            
        case .verifyOTP:
            return "\(AppUrl.APIPATCH)/verifyOTP"
            
        case .resetPassword:
            return "\(AppUrl.APIPATCH)/resetPassword"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .register :
            return .post
            
        case .login:
            return .post
            
        case .socialLogin:
            return .post
            
        case .editSocialProfile:
            return .put
        
        case .generateOTP:
            return .post
            
        case .verifyOTP:
            return .post
            
        case .resetPassword:
            return .post
        }
    }
    
    var body: [String : Any?]? {
        switch self {
        case .register(let name,
                       let email,
                       let password,
                       let gender,
                       let age,
                       let height,
                       let weight,
                       let foodPreferenceIds,
                       let foodDislikes):
            let params = ["name": name,
                          "email": email,
                          "password": password,
                          "gender": gender,
                          "age": age,
                          "height": height,
                          "weight": weight,
                          "food_preference": foodPreferenceIds,
                          "food_dislikes": foodDislikes] as [String : Any]
            return params
            
        case .login(let email, let password):
            let params = ["email": email,
                          "password" : password]
            return params
            
        case .socialLogin(let social_key,
                          let social_token ,
                          let email,
                          let name,
                          let device_id):
            let params = ["social_key" : social_key,
                          "social_token" : social_token,
                          "email" : email,
                          "name": name,
                          "device_id": device_id]
            return params
            
        case .editSocialProfile(let user_id,
                                let gender,
                                let age,
                                let height,
                                let weight,
                                let food_preferenceIDs,
                                let food_dislikes):
            let params = ["user_id" : user_id,
                          "gender" :gender,
                          "age": age,
                          "height":height ,
                          "weight": weight,
                          "food_preference":food_preferenceIDs,
                          "food_dislikes": food_dislikes] as [String : Any]
            return params
            
        case .generateOTP(let email):
            let params = ["email" : email]
            return params
            
        case .verifyOTP(let email, let otp):
            let params = ["email": email,
                          "otp": otp]
            return params
            
        case .resetPassword(let email, let password):
            let params = ["email": email,
                          "password": password]
            return params
        }
    }
    
    
}

