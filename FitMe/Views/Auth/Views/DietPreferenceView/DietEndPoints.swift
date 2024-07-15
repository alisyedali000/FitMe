//
//  DietEndPoints.swift
//  FitMe
//
//  Created by Ali Syed on 04/12/2023.
//

import Foundation
import Foundation
enum DietEndPoints {
  
    case dietPreferencesAgainstID
    case dietPreferences
    case updateFoodPreference(foodPreferenceIds: [String])
    
    case foodCategories
    
    case foodDislikes(food_category_id : String)
    case foodDislikesAgainstID(food_category_id : String)
    
    case searchDislike(searchText: String)
    case updateFoodDislike(dislikeFoodIds: [String])
   
}
extension DietEndPoints: Endpoint{
    var path: String {
        switch self {
            
        case .dietPreferences:
                  return "\(AppUrl.APIPATCH)/foodPreferences"
            
        case .dietPreferencesAgainstID:
            return "\(AppUrl.APIPATCH)/profile/getFoodPreference"
            
        case .foodCategories:
            return "\(AppUrl.APIPATCH)/foodCategories"
            
        case .foodDislikesAgainstID:
            return "\(AppUrl.APIPATCH)/profile/getDeslike"
            
        case .foodDislikes:
                   return "\(AppUrl.APIPATCH)/foodSubCategories"
            
        case .updateFoodPreference:
            return "\(AppUrl.APIPATCH)/profile/updateFoodPreference"
        
        case .updateFoodDislike:
            return "\(AppUrl.APIPATCH)/profile/updateFoodDislike"
        
        case .searchDislike:
            return "\(AppUrl.APIPATCH)/profile/searchDislike"
        }
        
        
    }
    
    var method: RequestMethod {
        switch self {
        case .dietPreferencesAgainstID:
            return .post
            
        case .dietPreferences:
                return .get
            
        case .foodCategories:
            return .get
            
        case .foodDislikesAgainstID:
            return .post
            
        case .foodDislikes:
                return .post
            
        case .updateFoodPreference:
            return .put
            
        case .updateFoodDislike:
            return .put
            
        case .searchDislike:
            return .post
        }
    }
    
    var body: [String : Any?]? {
        switch self {
            
        case .foodDislikes(let food_category_id):
              let params = ["food_category_id" : food_category_id]
              return params
            
        case .foodDislikesAgainstID(let food_category_id):
            
            let params = ["user_id" : user_id,
                "food_category_id" : food_category_id]
            return params
            
        case .dietPreferencesAgainstID:
            let params = ["user_id" : user_id]
            return params
            
        case .dietPreferences:
            return nil
            
        case .foodCategories:
            return nil
            
        case .updateFoodPreference(let foodPreferenceIds):
            
            let params = ["user_id" : user_id,
                          "food_preference": foodPreferenceIds] as [String : Any]
            return params
            
        case .updateFoodDislike(let dislikeFoodIds):
            let params = ["user_id" : user_id,
                          "food_dislikes": dislikeFoodIds] as [String : Any]
            return params
        case .searchDislike(let searchText):
            let params = ["user_id" : user_id,
                          "search": searchText]
            return params
        }
    }
}
