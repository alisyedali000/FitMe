//
//  AddRecipeModel.swift
//  FitMe
//
//  Created by Ali Syed on 12/12/2023.
//

import Foundation
import Foundation

// MARK: - Welcome
struct AddRecipeModel: Codable {
    var name, minutes, image, serves: String
    var foodCategory, difficulty, calories: String
    var carbohydrates, protein, fats: String
    var ingredients: [IngredientModel]
    var foodPreferences: [String]
    var method, addedBy, userID: String
    var recipeID: String

    enum CodingKeys: String, CodingKey {
        case name, minutes, image, serves
        case foodPreferences = "food_preference"
        case foodCategory = "food_category"
        case difficulty, calories, carbohydrates, protein, fats, ingredients, method
        case addedBy = "added_by"
        case userID = "user_id"
        case recipeID = "recipe_id"
    }
}
extension AddRecipeModel{
    init(){
        self.name = ""
        self.minutes = ""
        self.image = ""
        self.serves = ""
        self.foodCategory = ""
        self.difficulty = ""
        self.calories = ""
        self.carbohydrates = ""
        self.protein = ""
        self.fats = ""
        self.ingredients = [IngredientModel]()
        self.method = ""
        self.addedBy = ""
        self.userID = ""
        self.recipeID = ""
        self.foodPreferences = []
    }
    
}

// MARK: - Ingredient
struct IngredientModel: Codable, Equatable {
    var id, quantity, scale: String?
}

struct SearchesResponse: Codable, Hashable {
    let id: Int
    let name: String
}
