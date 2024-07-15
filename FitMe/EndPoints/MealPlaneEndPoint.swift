//
//  MealPlaneEndPoint.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 22/12/2023.
//

import Foundation

import Foundation
enum MealPlanEndPoint {
    
    case todayMealPlan
    case weeklyMealPlan(day: String)
    case addToMealPlan(recipeId: Int, mealTime: String, mealType: String, days: [String])
    case mealHistory(date: String)
}
extension MealPlanEndPoint : Endpoint {
    
    
    var path: String {
        switch self {
            
        case .todayMealPlan:
            return "\(AppUrl.APIPATCH)/mealPlan/todayMealPlan"
            
        case .weeklyMealPlan:
            return "\(AppUrl.APIPATCH)/mealPlan/weeklyMealPlan"
            
        case .addToMealPlan:
            return "\(AppUrl.APIPATCH)/mealPlan/addToMealPlan"
            
        case .mealHistory:
            return "\(AppUrl.APIPATCH)/mealPlan/mealHistory"
        }
    }
    
    var method: RequestMethod {
        switch self {
            
        case .todayMealPlan:
            return .post
            
        case .weeklyMealPlan:
            return .post
            
        case .addToMealPlan:
            return .post
            
        case .mealHistory:
            return .post
        }
    }
    
    var body: [String : Any?]? {
        switch self {
            
            
        case .todayMealPlan:
            let params = [
                "user_id":user_id,
            ] as [String : Any]
            
            return params
            
        case .weeklyMealPlan(let day):
            
            let params = [
                "user_id":user_id,
                "day": day
            ] as [String : Any]
            
            return params
            
        case .addToMealPlan(let recipeId, let mealTime, let mealType, let days):
            
            let params = [
                "user_id":user_id,
                "recipe_id": recipeId,
                "meal_time": mealTime,
                "meal_type": mealType,
                "days": days
            ] as [String : Any]
            return params
            
        case .mealHistory(let date):
            let params = [
                "user_id":user_id,
                "date": date
            ] as [String : Any]
            return params
        }
    }
}


