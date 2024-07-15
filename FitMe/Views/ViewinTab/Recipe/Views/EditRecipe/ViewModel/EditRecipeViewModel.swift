//
//  EditRecipeViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 02/01/2024.
//

import Foundation

class EditRecipeViewModel: FitMeBaseViewModel {
    
    
    @Published var difficultyOptions = ["Easy", "Medium", "Hard"]
    
    @Published var preferenceOptions = [DietPreference]()
    //    this is something incorrent but for now we need to run the applicaiton
    @Published var selectedPreferencesNames: [String] = []
    @Published var recipeCategoryOtions = [FoodCategories]()
    @Published var selectedRecipeCategory = FoodCategories()
    
    @Published var recipeIngredients = [Ingredient]()
    @Published var recipeIngredientS = [IngredientModel]()
    
    @Published var carbohydrates = 0.0
    @Published var protein = 0.0
    @Published var fats = 0.0
    @Published var recipe = AddRecipeModel()
    
    @Published var updatedRecipeModel: RecipeModel?
    
    @Published var reciePreferenceName = ""
    
    
//     A lot of junk code here
    init(recipe: RecipeModel) {
        super.init()
//        reciePreferenceName = recipe.foodPreference.name
//        self.recipe.foodPreference = recipe.foodPreference
//        selectedPreferenceId = recipe.foodPreference.id
        
        selectedPreferencesNames = recipe.foodPreferences.map { $0.name }
        
        self.recipe.image = recipe.image
        self.recipe.name = recipe.name
        self.recipe.minutes = recipe.minutes
        self.recipe.difficulty = recipe.difficulty
        self.recipe.serves = recipe.serves
        self.recipe.calories = recipe.calories
        
        self.recipe.carbohydrates = recipe.carbohydrates
        self.recipe.protein = recipe.protein
        self.recipe.fats = recipe.fats
        
        self.carbohydrates = Double(recipe.carbohydrates) ?? 0.0
        self.protein = Double(recipe.protein) ?? 0.0
        self.fats = Double(recipe.fats) ?? 0.0
        
        self.recipeIngredients = recipe.ingredients

        self.recipe.method = recipe.method
        self.recipe.recipeID = String(recipe.id)
        
    }
    
    
}


extension EditRecipeViewModel{
    
    
    
    func setIngredientForEditRecipe(){
        for ingredient in recipeIngredients {
            var ing = IngredientModel()
            ing.id = "\(ingredient.id)"
            ing.quantity = ingredient.quantity
            ing.scale = ingredient.scale
            
            if let existingIndex = self.recipeIngredientS.firstIndex(where: { $0.id == ing.id }) {
                self.recipeIngredientS[existingIndex] = ing
            } else {
                self.recipeIngredientS.append(ing)
            }
        }
        //        self.recipe.minutes += "Min(s)"
        self.recipe.userID = user_id
        self.recipe.ingredients = self.recipeIngredientS
        self.recipe.carbohydrates = "\(self.carbohydrates)"
        self.recipe.fats = "\(self.fats)"
        self.recipe.protein = "\(self.protein)"
        self.recipe.addedBy = "user"
        
        let selectedPreferenceIds = preferenceOptions
            .filter { selectedPreferencesNames.contains($0.name) }
            .compactMap { String($0.id) }

        recipe.foodPreferences = selectedPreferenceIds


    }
    
    func validateRecipe() -> Bool{
        
        setIngredientForEditRecipe()
        
        if recipe.name.isEmpty{
            showError(message: "Name field is required!")
            return false
        }
        if recipe.minutes.isEmpty{
            showError(message: "Duration field is required!")
            return false
        }
        if recipe.image.isEmpty{
            showError(message: "Please attach an Image!")
            return false
        }
        if recipe.serves.isEmpty{
            showError(message: "No. of serving is missing!")
            return false
        }
//        
//        if recipe.foodCategory.isEmpty{
//            showError(message: "Recipe category is not selected!")
//            return false
//        }
        if recipe.difficulty.isEmpty{
            showError(message: "Please select difficulty level!")
            return false
        }
        if recipe.calories.isEmpty{
            showError(message: "Total number of calories is required!")
            return false
        }
        
        if recipe.carbohydrates == "0.0" && recipe.protein == "0.0" && recipe.fats == "0.0"{
            showError(message: "Atlease one Nutrients must be specified!")
            return false
            
        }
        
        
        if recipe.method.isEmpty{
            showError(message: "Instructions are not filled out!")
            return false
        }
        
        if recipe.ingredients.isEmpty{
            showError(message: "Ingredients are not added!")
            return false
        }else{
            for ingredient in recipe.ingredients{
                
                if ingredient.quantity!.isEmpty{
                    showError(message: "Please specify the quantity for ingredients!")
                    return false
                    
                    
                }
                if ingredient.scale!.isEmpty{
                    showError(message: "Please specify scale for ingredients!")
                    return false

                }
                
            }
        }
        
        return true
    }
    
  

    
}

extension EditRecipeViewModel: NetworkManagerService {
    @MainActor func getDietPreferences() async {
        
        self.showLoader = true
        let endPoint : DietEndPoints = .dietPreferences
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[DietPreference]>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            self.preferenceOptions = data.data ?? [DietPreference]()
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func getFoodCategories() async {
        
        self.showLoader = true
        let endPoint : DietEndPoints = .foodCategories
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[FoodCategories]>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            self.recipeCategoryOtions = data.data ?? [FoodCategories]()
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
    }
    
    @MainActor func requestEditRecipe() async {
        
        
        self.showLoader = true
        let endPoint : RecipeEndPoints = .editRecipe(recipe: self.recipe)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<RecipeModel>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
//
//            debugPrint(data.message ?? "")
//            debugPrint(data.status ?? "")
//            debugPrint(data.data as Any)
            if data.status ?? false{
                showError(message: "Recipe added successfully!")
                
                self.recipe = AddRecipeModel()
                updatedRecipeModel = data.data
                self.isSuccess = true
                //                self.recipeDetail = data.data ??
            }else{
                showError(message: data.message ?? "Network Error!")
            }
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    
    
}


