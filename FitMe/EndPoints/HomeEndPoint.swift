//
//  HomeEndPoint.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 20/12/2023.
//

import Foundation


enum HomeEndPoint {
    
    case searchRecipe(searchText : String)
    case saveOrUnsaveRecipe(recipe_id : Int, isSaved: Bool)
    case discoverRecipes(page: Int, disklike: Bool)
    case fitmeHome
    case setGoal(userGoal: UserGoal)
    case userGoalHistory(startDate: String, endDate: String)
    
}
extension HomeEndPoint : Endpoint {
    
    
    var path: String {
        switch self {
            //        case .addRecipe:
            //            return "\(AppUrl.APIPATCH)/recipe/addRecipe"
            //
        case .searchRecipe:
            return "\(AppUrl.APIPATCH)/recipe/searchRecipe"
        case .saveOrUnsaveRecipe:
            return "\(AppUrl.APIPATCH)/recipe/saveOrUnsaveRecipe"
            //
        case .discoverRecipes:
            return "\(AppUrl.APIPATCH)/recipe/discoverRecipies"
            
        case .fitmeHome:
            return "\(AppUrl.APIPATCH)/home/fitmeHome"
            
        case .setGoal:
            return "\(AppUrl.APIPATCH)/goal/setGoal"
            
        case .userGoalHistory:
            return "\(AppUrl.APIPATCH)/goal/userGoalHistory"
        }
    }
    
    var method: RequestMethod {
        switch self {
            //        case .addRecipe :
            //            return .post
            //
        case .searchRecipe:
            return .post
            
        case .saveOrUnsaveRecipe:
            return .post
            //
        case .discoverRecipes:
            return .post
            
        case .fitmeHome:
            return .post
            
        case .setGoal:
            return .post
        case .userGoalHistory:
            return .post
        }
    }
    
    var body: [String : Any?]? {
        switch self {
            //        case .addRecipe(let recipe):
            //            let params = getParamsFromCodable(object: recipe)
            //            return params
            //
        case .searchRecipe(let searchText) :
            let params = [
                "user_id": user_id,
                "search": searchText,
                "deslike": true
            ] as [String : Any]
            return params
            
        case .saveOrUnsaveRecipe(let recipe_id, let isSaved):
            let params = [
                "user_id": user_id,
                "recipe_id": recipe_id,
                "isSaved": isSaved
                
            ] as [String: Any]
            return params
            
        case .discoverRecipes(let page, let dislike):
            let params = [
                "user_id": user_id,
                "page": page,
                "deslike": dislike
            ] as [String : Any]
            return params
            
        case .fitmeHome:
            let params = [
                "user_id": user_id,
            ] as [String : Any]
            return params
            
        case .setGoal(let userGoal):
            let params = [
                "user_id": user_id,
                "calories": userGoal.calories ?? "",
                "carbohydrates": userGoal.carbohydrates ?? "",
                "protein": userGoal.protein ?? "",
                "fats": userGoal.fats ?? ""
                
            ] as [String : Any]
            return params
            
        case .userGoalHistory(let startDate, let endDate):
            let params = [
                "user_id": user_id,
                "start_date": startDate,
                "end_date": endDate
                
            ] as [String : Any]
            return params
        }
    }
    
    
}


