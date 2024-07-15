//
//  ShoppingItem.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 26/12/2023.
//

import Foundation
import SwiftData

@Model
class ShoppingItem {
    
    var id: UUID
    var quantity: String
    var name: String
    var measuringUnit: String
    var isChecked: Bool
    var createAt: Date
    var recipeID : Int? // Extra optional argument was added to keep the track of ingredients for recipe ... to get to know which ingredient belongs to which recipe but it is not used.
    
    init(id: UUID, quantitly: String, name: String, measuringUnit: String, isChecked: Bool, createAt: Date, recipeID: Int? = nil) {
        self.id = id
        self.quantity = quantitly
        self.name = name
        self.measuringUnit = measuringUnit
        self.isChecked = isChecked
        self.createAt = createAt
        self.recipeID = recipeID
    }
}




let mockShoppingList = [
    
    ShoppingItem(id: UUID(), quantitly: "2", name: "Milk", measuringUnit: "tbs", isChecked: false, createAt: Date()),
    ShoppingItem(id: UUID(), quantitly: "1", name: "Bread", measuringUnit: "grams", isChecked: true, createAt: Date()),
    ShoppingItem(id: UUID(), quantitly: "3", name: "Eggs", measuringUnit: "tbs", isChecked: false, createAt: Date())
    
]


