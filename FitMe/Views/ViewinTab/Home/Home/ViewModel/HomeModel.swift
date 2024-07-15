//
//  HomeModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 27/12/2023.
//

import Foundation


// MARK: - DataClass
struct HomeModel: Codable {
    let userGoal, todayIntake: UserGoal
    let todayMealPlan: TodayMealPlan

    enum CodingKeys: String, CodingKey {
        case userGoal = "User_goal"
        case todayIntake = "Today_Intake"
        case todayMealPlan = "Today_Meal_Plan"
    }
}

// MARK: - TodayIntake
struct UserGoal: Codable {
    
    var userID: String? = ""
    var calories: String? = ""
    var carbohydrates: String? = ""
    var protein: String? = ""
    var fats: String? = ""
    
    
    init() {
        
    }
    
    init(userID: String, calories: String, carbohydrates: String, protein: String, fats: String) {
        self.userID = userID
        self.calories = calories
        self.carbohydrates = carbohydrates
        self.protein = protein
        self.fats = fats
    }
    
    
    var caloriesInt: Int {
        return Int(calories ?? "0") ?? 0
    }
    var carbohydratesInt: Int {
        return Int(carbohydrates ?? "0"  ) ?? 0
    }
    var proteinInt: Int {
        return Int(protein ?? "0" ) ?? 0
    }
    var fatsInt: Int {
        return Int(fats ?? "0" ) ?? 0
    }
    
//    get the percentage valuse.
    var carbohydratesPercentage: Int {
        
        let caloriesInt = Double(caloriesInt)
        if caloriesInt == 0 {return 0}
        return Int(ceil((Double(carbohydratesInt) / (caloriesInt * 0.25)) * 100.0))
    }
    var proteinPercentage: Int {
        let caloriesInt = Double(caloriesInt)
        if caloriesInt == 0 {return 0}
        return Int(ceil((Double(proteinInt) / (caloriesInt * 0.25)) * 100.0))
    }
    var fatsPercentage: Int {
        // Assuming caloriesInt and fatsInt are properties of your class or struct
        let calories = Double(caloriesInt)
        if calories == 0 {return 0}
        let fats = Double(fatsInt)

        let fatRatio = fats / (calories * 0.11)
        let percentage = fatRatio * 100.0
        let flooredPercentage = ceil(percentage)
        let result = Int(flooredPercentage)

        return result
        

    }


    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case calories, carbohydrates, protein, fats
    }
    
    // Function to calculate percentages
    func calculatePercentages() -> (carbohydrates: Double, fats: Double, protein: Double) {
        let totalGrams = Double(carbohydratesInt + proteinInt + fatsInt)

        // Check for division by zero or other problematic scenarios
        guard totalGrams != 0 else {
            return (carbohydrates: 0, fats: 0, protein: 0)
        }

        let carbohydratesPercentage = Double(carbohydratesInt) / totalGrams
        let fatsPercentage = Double(fatsInt) / totalGrams
        let proteinPercentage = Double(proteinInt) / totalGrams

        return (carbohydrates: carbohydratesPercentage, fats: fatsPercentage, protein: proteinPercentage)
    }

    
}

// MARK: - TodayMealPlan
struct TodayMealPlan: Codable {
    let breakfast, lunch, dinner, snacks: [RecipeModel]
}
