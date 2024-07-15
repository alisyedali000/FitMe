//
//  UserDetails.swift
//  FitMe
//
//  Created by Ali Syed on 01/12/2023.
//

import Foundation

protocol DropdownDisplayable {
    var displayName: String { get }
    var index: Int { get }
}


struct UserDetails: Codable, Hashable {
    let id: Int
    let name, email, gender, age: String
    let height, weight, profilePic: String
    let foodPreference: [DietPreference]
    let foodDislikes: [FoodDislikes]
    let deviceID, aCode, gCode, emailCode: String?
    let createdAt, updatedAt: String?
    let firstLogin: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, email, gender, age, height, weight
        case profilePic = "profile_pic"
        case foodPreference = "food_preference"
        case foodDislikes = "food_dislikes"
        case deviceID = "device_id"
        case aCode = "a_code"
        case gCode = "g_code"
        case emailCode = "email_code"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstLogin = "first_login"
    }
}


struct DietPreference: Codable, Hashable, Identifiable, DropdownDisplayable, Selectable {

    let id: Int
    let name: String
    var select: Bool?

    var displayName: String {
        return name 
    }
    
    var index: Int {
        return id 
    }
    
    var isSelected: Bool {
        return select ?? false
    }
    
    
}
extension DietPreference{
    init(){
        self.id = 0
        self.name = ""
        self.select = false
    }
}
struct FoodDislikes: Codable, Hashable {
    var id: Int
    var name: String
    var foodCategoryID: String?
    var select: Bool?
    
    var isSelected: Bool {
        return select ?? false
    }

    enum CodingKeys: String, CodingKey {
        case id, name, select
        case foodCategoryID = "food_category_id"
    }
}



typealias FoodCategories = DietPreference

let mockDietPreference: [DietPreference] = [
    DietPreference(id: 1, name: "Keto", select: true),
    DietPreference(id: 2, name: "Vegetarian", select: false),
    DietPreference(id: 3, name: "Vegan", select: false),
    DietPreference(id: 4, name: "Paleo", select: false),
    DietPreference(id: 5, name: "Mediterranean", select: false),
    DietPreference(id: 6, name: "Pescatarian", select: false),
    DietPreference(id: 7, name: "Flexitarian", select: false),
    DietPreference(id: 8, name: "Gluten-Free", select: true),
    DietPreference(id: 9, name: "Low-Carb", select: true),
    DietPreference(id: 10, name: "Low-Fat", select: true),
    // Add more diet preferences as needed
]
