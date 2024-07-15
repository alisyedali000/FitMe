//
//  RecipeEndPoints.swift
//  FitMe
//
//  Created by Ali Syed on 11/12/2023.
//

import Foundation
enum RecipeEndPoints {
    case addRecipe(recipe : AddRecipeModel)
    case editRecipe(recipe : AddRecipeModel)
    case getRecipeDetails(recipe_id : String)
    case getAllUserRecipes
    case allSaveRecipiesBelongsToUser
    
    case deleteRecipe(recipe_id: String)
    case deleteFromMealPlan(recipe_id: String, mealType: String, mealTime: String, day: String)
    case eatenOrSkippedMeal(recipe_id: String, eatenStatus: String, meal_type: String)
    case searchRecipe(search: String)
    
    case getRecentSearches
    case recentSearch(recipe_id : String)
    case deleteRecentSearch(recipe_id: String)
    
    
}
extension RecipeEndPoints : Endpoint {
    
    
    var path: String {
        switch self {
        case .addRecipe:
            return "\(AppUrl.APIPATCH)/recipe/addRecipe"
            
        case .editRecipe:
            return "\(AppUrl.APIPATCH)/recipe/editRecipe"
            
        case .getRecipeDetails:
            return "\(AppUrl.APIPATCH)/recipe/recipeDetail"
            
        case .getAllUserRecipes:
            return "\(AppUrl.APIPATCH)/recipe/recipiesBelongsToUser"
            
        case .searchRecipe:
            return "\(AppUrl.APIPATCH)/recipe/searchUserRecipe"
            
        case .deleteRecipe:
            return "\(AppUrl.APIPATCH)/recipe/deleteRecipe"
            
        case .deleteFromMealPlan:
            return "\(AppUrl.APIPATCH)/mealPlan/deleteMeal"
            
        case .getRecentSearches:
            return "\(AppUrl.APIPATCH)/recipe/myRecentSearch"
            
        case .recentSearch:
            return "\(AppUrl.APIPATCH)/recipe/recentSearch"
            
        case .deleteRecentSearch:
            return "\(AppUrl.APIPATCH)/recipe/deleteRecentSearch"
            
        
        case .eatenOrSkippedMeal:
            return "\(AppUrl.APIPATCH)/mealPlan/eatenOrSkippedMeal"
            
        case .allSaveRecipiesBelongsToUser:
            return "\(AppUrl.APIPATCH)/recipe/allSaveRecipiesBelongsToUser"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .addRecipe :
            return .post
            
        case .editRecipe:
            return .patch
            
        case .getRecipeDetails:
            return .post
            
        case .getAllUserRecipes:
            return .post
            
        case .deleteRecipe:
            return .post
        
        case .deleteFromMealPlan:
            return .post
            
        case .searchRecipe:
            return .post
            
        case .getRecentSearches:
            return .post
            
        case .recentSearch:
            return .post
            
        case .deleteRecentSearch:
            return .post
            
        case .eatenOrSkippedMeal:
            return .post
        case .allSaveRecipiesBelongsToUser:
            return .post
        
        }
    }
    
    var body: [String : Any?]? {
        switch self {
        case .addRecipe(let recipe):
            let params = getParamsFromCodable(object: recipe)
            return params
            
        case .editRecipe(let recipe):
            let params = getParamsFromCodable(object: recipe)
            return params
            
        case .getRecipeDetails(let recipe_id):
            let params = ["user_id":user_id,
                          "recipe_id":recipe_id]
            return params
            
        case .getAllUserRecipes:
            let params = ["user_id":user_id]
            return params
            
        case .allSaveRecipiesBelongsToUser:
            let params = ["user_id":user_id]
            return params
            
        case .deleteRecipe(let recipe_id):
            let params = ["user_id": user_id,
                          "recipe_id":recipe_id]
            return params
            
        case .deleteFromMealPlan(let recipe_id, let mealType, let mealTime, let day):
            let params = ["user_id": user_id,
                          "recipe_id":recipe_id,
                          "meal_type": mealType,
                          "meal_time": mealTime,
                              "day": day]
            
            return params
            
        case .searchRecipe(let search):
            let params = ["user_id":user_id,
                          "search":search]
            return params
            
            
        case .getRecentSearches:
            let params = ["user_id":user_id]
            return params
            
        case .deleteRecentSearch(let recipe_id):
            let params = ["user_id":user_id,
                          "recipe_id":recipe_id]
            return params
            
        case .recentSearch(let recipe_id):
            let params = ["user_id":user_id,
                          "recipe_id":recipe_id]
            return params

        case .eatenOrSkippedMeal(let recipe_id, let eatenStatus, let meal_type):
            let params = ["user_id":user_id,
                          "recipe_id":recipe_id,
                          "meal_type": meal_type,
                          "status": eatenStatus]
            return params
        }
    }
    
    
}


