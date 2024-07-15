//
//  RecipeModel.swift
//  FitMe
//
//  Created by Ali Syed on 11/12/2023.
//

import Foundation
struct RecipeModel: Codable, Identifiable, Equatable, Hashable {
    static func == (lhs: RecipeModel, rhs: RecipeModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    let name, minutes, image, serves: String
    let foodPreferences: [FoodPreference]
    let foodCategory, difficulty, calories, carbohydrates: String
    let protein, fats: String
    let ingredients: [Ingredient]
    let method, addedBy, userID, createdAt: String
    let updatedAt: String
    let addedByDetail: AddedByDetail
    var saved: Bool
    var foodEaten, foodSkipped: Int?
    
    var mealType: String?
    
    var ingredientsString: [String] {
          return ingredients.map { ingredient in
              return ingredient.name
          }
      }
    
    var minutesValue: Int? {
        // Extracting the numeric value from the "minutes" property
        let numericValueString = minutes.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                            .joined()
        return Int(numericValueString)
    }
    
    var idString: String {
        return String(id)
    }
    
    
    enum CodingKeys: String, CodingKey {
        
        case id, name, minutes, image, serves
        case foodPreferences = "food_preference"
        case foodCategory = "food_category"
        case difficulty, calories, carbohydrates, protein, fats, ingredients, method
        case addedBy = "added_by"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case addedByDetail = "added_by_detail"
        case saved
        case foodEaten = "food_eaten"
        case foodSkipped = "food_skipped"
        
    }
    
    
}

// MARK: - AddedByDetail
struct AddedByDetail: Codable, Hashable {
    let name, image: String
}

// MARK: - FoodPreference
struct FoodPreference: Codable, Hashable {
    var id: Int = 0
    var name: String = ""
    
}

// MARK: - Ingredient
struct Ingredient: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    var name, quantity, scale: String
    
}



let mockRecipes: [RecipeModel] = [
    RecipeModel(
        id: 34,
        name: "Simple lemon pepper salmon for one",
        minutes: "20",
        image: "recipies_images/iJreQoQHwgTtMvH.png",
        serves: "1",
        foodPreferences:[ FoodPreference(id: 1, name: "Vegan")],
        foodCategory: "0",
        difficulty: "Hard",
        calories: "1920",
        carbohydrates: "2.0",
        protein: "33.0",
        fats: "26.0",
        ingredients: [
            Ingredient(id: 9, name: "Chicken", quantity: "2", scale: "tsp"),
            Ingredient(id: 6, name: "Ginger", quantity: "1", scale: "tsp")
        ],
        method: "Prepare a small baking dish with alfoil, using enough foil to create a pocket around the fish. Lightly spray foil and salmon with olive oil. Cut a few slices of lemon, then juice the remainder. Pour lemon juice around the salmon, cover with cracked pepper to your taste and top with lemon slices. Cover with foil, creating a pocket for the salmon to cook. Bake at 180°C for 20 minutes for medium to well done. Remove from foil and discard lemon slices. Serve with mashed low GI potato mash (or try cauliflower mash) and steamed vegetables.",
        addedBy: "user",
        userID: "52",
        createdAt: "2023-12-19T06:04:14.000000Z",
        updatedAt: "2023-12-19T06:04:14.000000Z",
        addedByDetail: AddedByDetail(name: "Sakina", image: "users_profile/GPET666EWuNgPOT.png"),
        saved: false,
        mealType: "breakfast"
    ),
    RecipeModel(
        id: 35,
        name: "numan",
        minutes: "34",
        image: "recipies_images/1702985821_6581805d1b76d.png",
        serves: "45",
        foodPreferences: [FoodPreference(id: 3, name: "None")],
        foodCategory: "2",
        difficulty: "Easy",
        calories: "234",
        carbohydrates: "27",
        protein: "25",
        fats: "30",
        ingredients: [
            Ingredient(id: 6, name: "Ginger", quantity: "78", scale: "grams")
        ],
        method: "fhf",
        addedBy: "fitme",
        userID: "",
        createdAt: "2023-12-19T11:37:01.000000Z",
        updatedAt: "2023-12-19T13:19:03.000000Z",
        addedByDetail: AddedByDetail(name: "Fitme", image: ""),
        saved: false
    ),
    RecipeModel(
        id: 38,
        name: "Numan",
        minutes: "50",
        image: "recipies_images/1702992056_658198b8bf9f2.png",
        serves: "34",
        foodPreferences: [FoodPreference(id: 2, name: "Diary Free")],
        foodCategory: "2",
        difficulty: "Easy",
        calories: "34",
        carbohydrates: "52",
        protein: "51",
        fats: "14",
        ingredients: [
            Ingredient(id: 10, name: "Keema", quantity: "23", scale: "tsp")
        ],
        method: "dfddfd",
        addedBy: "fitme",
        userID: "",
        createdAt: "2023-12-19T13:20:56.000000Z",
        updatedAt: "2023-12-19T13:23:32.000000Z",
        addedByDetail: AddedByDetail(name: "Fitme", image: ""),
        saved: false
    )
]

