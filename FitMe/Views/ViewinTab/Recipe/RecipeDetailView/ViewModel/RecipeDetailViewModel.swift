//
//  RecipeDetailViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 20/12/2023.
//

import Foundation

class RecipeDetailViewModel: FitMeBaseViewModel {
    
    //    MARK: - Add recipe to meal Variable
    @Published var mealSelectionTime = ""
    @Published var mealSelectionType = ""
    @Published var selectedDays: [String] = []
}

extension RecipeDetailViewModel {
    
    func parseMealDay(mealDay: String) -> (time: String, day: String) {
        let components = mealDay.components(separatedBy: "-")

        if components.count == 1 {
            return (time: components[0], day: "")
        } else if components.count == 2 {
            return (time: components[0], day: components[1])
        } else {
            // Handle invalid input, you can choose to return default values or throw an error
            return (time: "unknown", day: "unknown")
        }
    }
    
    func resetMealSelection() {
        mealSelectionTime = ""
        mealSelectionType = ""
        selectedDays = []
    }
    
    
}


extension RecipeDetailViewModel: NetworkManagerService {
    
    @MainActor func requestAddRecipeToMealPlan(recipe: RecipeModel) async {
        
        
        mealSelectionTime = mealSelectionTime.lowercased()
        mealSelectionType = mealSelectionType.lowercased()
        selectedDays = selectedDays.map { $0.lowercased() }
        
        self.showLoader = true
        let endPoint : MealPlanEndPoint = .addToMealPlan(recipeId: recipe.id, mealTime: mealSelectionTime, mealType: mealSelectionType, days: selectedDays)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GenericResponse>.self)
        self.showLoader = false

        switch request {
            
        case .success(let data):
            
            if data.status!{
                isSuccess = true
                showError(message: data.message ?? "")
                
            } else {
                isSuccess = false
                showError(message: data.message!)
            }
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        resetMealSelection()
        
    }

    
    @MainActor func deleteRecipe(recipe_id: String) async {
        
        //        self.setIngredient()
        
        self.showLoader = true
        let endPoint : RecipeEndPoints = .deleteRecipe(recipe_id: recipe_id)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GenericResponse>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                self.isSuccess = true
                //                showError(message: "Recipe added successfully!")
            }else{
                showError(message: data.message!)
            }
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
    }
    
    @MainActor func requestDeleteFromMealPlan(recipe_id: String, mealType: String, mealDay: String) async -> Bool {
        
        let (mealTime, day) = parseMealDay(mealDay: mealDay)
        
        
        self.showLoader = true
        let endPoint : RecipeEndPoints = .deleteFromMealPlan(recipe_id: recipe_id, mealType: mealType, mealTime: mealTime, day: day)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GenericResponse>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            if data.status!{
                return true
            }else{
                showError(message: data.message!)
                return false
            }
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            return false
            
        }
    }
    
    
    @MainActor func requestRecipeTaken(recipe_id: String, eatenStatus: String, meal_type: String) async -> Bool {

        self.showLoader = true
        let endPoint : RecipeEndPoints = .eatenOrSkippedMeal(recipe_id: recipe_id,
                                                             eatenStatus: eatenStatus,
                                                             meal_type: meal_type)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<RecipeModel>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            if data.status!{
                showError(message: data.message ?? "")
                return true
            }else{
                showError(message: data.message!)
                return false
            }
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            return false
            
        }
    }
    
    
    
}
