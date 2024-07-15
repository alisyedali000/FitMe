//
//  MealPlaneModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 22/12/2023.
//

import Foundation


// MARK: - DataClass
struct WeeklyMealPlan: Codable {
    let intake: UserGoal
    let mealPlan: MealPlaneModel

    enum CodingKeys: String, CodingKey {
        case intake
        case mealPlan = "Meal_plan"
    }
}

struct MealPlaneModel: Codable {
    let breakfast, lunch, dinner, snacks : [RecipeModel]
    
}
