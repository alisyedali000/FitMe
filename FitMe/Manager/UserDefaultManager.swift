//
//  UserDefaultManager.swift
//  FitMe
//
//  Created by Ali Syed on 04/12/2023.
//

import Foundation
import Combine
import SwiftUI

enum UserDefaultEnum: String {
    case userDetails
    case socialLogin
    case userGoal

}


class UserDefaultManager {
    
    static let shared = UserDefaultManager()
    let userDefaults : UserDefaults = UserDefaults.standard
    
    // this will return the empty stirng if no value is founded into UserDefaults.
    var userId: Int {
        return UserDefaultManager.shared.get()?.id ?? 0
    }
    
    
    // this will return the empty stirng if no value is founded into UserDefaults.
    var userName: String {
        return UserDefaultManager.shared.get()?.name ?? ""
    }
    
    var userImage: String {
        return UserDefaultManager.shared.get()?.profilePic ?? ""
    }
    
    static let Authenticated = PassthroughSubject<Bool, Never>()
    static let UpdateGoal = PassthroughSubject<Bool, Never>()
//    static let moveToLogin = PassthroughSubject<Bool, Never>()
    
    static func IsAuthenticated() -> Bool {
        //this means that userDefaults have some data
        return shared.get() != nil
    }
    
    /// save user object into userDefaults
    func set(user: UserDetails?) {
        if let User = user{
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(User) {
                userDefaults.set(encoded, forKey: UserDefaultEnum.userDetails.rawValue)
            }
        }
    }


    
    /// get the whole userObject form userDefaults.
    func get() -> UserDetails? {
   
        if let userData: Data =  userDefaults.object(forKey: UserDefaultEnum.userDetails.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(UserDetails.self, from: userData) {
                return user
            }
            print("User Decoder Error")
        }
//        print("User Not Found in UsersDefaults")
        return nil
    }
    
    

    
    /// Remove all the user infor from the userDefault
    func removeUser() {
        userDefaults.removeObject(forKey: UserDefaultEnum.userGoal.rawValue)
        userDefaults.removeObject(forKey: UserDefaultEnum.userDetails.rawValue)
        userDefaults.removeObject(forKey: UserDefaultEnum.socialLogin.rawValue)
        UserDefaultManager.Authenticated.send(false)
        UserDefaultManager.shared.setSocialLogin(false)
    }
    


    
    func setSocialLogin(_ bool : Bool){
        userDefaults.set(bool, forKey: "socialLogin")
    }
    func isSocialLogin() -> Bool{
        userDefaults.bool(forKey: "socialLogin")
    }
    
    func isSplashShown() -> Bool{
        userDefaults.bool(forKey: "splash")
    }
    func setSplashShownStatus(){
        userDefaults.set(true, forKey: "splash")
    }
}

// MARK: User Goal Setting

extension UserDefaultManager {
    
    func setUserGoal(userGoal: UserGoal?)  {
        if let userGoal {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(userGoal) {
                userDefaults.set(encoded, forKey: UserDefaultEnum.userGoal.rawValue)
            }
        }
    }
    
    func getUserGoal() -> UserGoal {
        if let userData: Data = userDefaults.object(forKey: UserDefaultEnum.userGoal.rawValue) as? Data {
            let decoder = JSONDecoder()
            if let userGoal = try? decoder.decode(UserGoal.self, from: userData) {
                return userGoal
            }
            print("User Goal Decoder Error")
        }
        // print("User Goal Not Found in UserDefaults")
        return UserGoal()
    }
    
}




