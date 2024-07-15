//
//  RecipeViewModel.swift
//  FitMe
//
//  Created by Ali Syed on 07/12/2023.
//

import Foundation
class RecipeViewModel: FitMeBaseViewModel{
    @Published var searchText = ""
    @Published var difficultyOptions = ["Easy", "Medium", "Hard"]
    
    @Published var preferenceOptions = [DietPreference]()
    //    this is something incorrent but for now we need to run the applicaiton
    //    @Published var selectedPreferenceId: Int?
    @Published var selectedPreferencesNames: [String] = []
    @Published var recipeCategoryOtions = [FoodCategories]()
    @Published var selectedRecipeCategory = FoodCategories()
    
    @Published var recipeIngredients = [Ingredient]()
    @Published var recipeIngredientS = [IngredientModel]()
    
    @Published var carbohydrates = 0.0
    @Published var protein = 0.0
    @Published var fats = 0.0
    @Published var recipe = AddRecipeModel()
    @Published var recipeDetail: RecipeModel?
    
    @Published var allRecipesByUser = [RecipeModel]()
    @Published var filteredRecipes = [RecipeModel]()
    @Published var recipesToShow = [RecipeModel]()
    
    @Published var recentSearches = [SearchesResponse]()
    @Published var url = ""
}

// MAKR: Custom function extension
extension RecipeViewModel {
    
    func updateRecipesList() {
        if searchText.isEmpty {
            recipesToShow = allRecipesByUser
        }
    }
    
}


extension RecipeViewModel : NetworkManagerService{
    
    @MainActor func addRecipe() async {
        
        
        self.showLoader = true
        let endPoint : RecipeEndPoints = .addRecipe(recipe: self.recipe)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponse.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            //
            //            debugPrint(data.message ?? "")
            //            debugPrint(data.status ?? "")
            //            debugPrint(data.data as Any)
            if data.status{
                showError(message: "Recipe added successfully!")
                self.isSuccess = true
                self.recipe = AddRecipeModel()
                //                self.recipeDetail = data.data ??
            }else{
                showError(message: data.message)
            }
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func saveRecipe(recipe_id: Int, isSaved: Bool) async -> Bool {
        
//        let selectedRecipe = recipes[index]
        self.showLoader = true
        let endPoint : HomeEndPoint = .saveOrUnsaveRecipe(recipe_id: recipe_id, isSaved: isSaved)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponse.self)
        showLoader = false
        
        switch request {
            
        case .success(let data):
            
            self.showError(message: data.message)
            return data.status
            
            
        case .failure(let error):
            debugPrint(error.customMessage)
            self.showError(message: error.customMessage)
            return false
        }
        
        
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
    
    func searchRecipe() {
        
        self.recipesToShow = self.allRecipesByUser.filter { recipe in
            // Assuming recipe.name is the property you want to search
            return recipe.name.lowercased().contains(searchText.lowercased())
        }
        
    }
    
    
    
    @MainActor func getAllRecipesByUser() async {
        
        
        self.showLoader = true
        let endPoint : RecipeEndPoints = .getAllUserRecipes
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[RecipeModel]>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            
            self.allRecipesByUser = data.data ?? [RecipeModel]()
            self.recipesToShow = self.allRecipesByUser
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func getSavedRecipes() async {
        
        
        self.showLoader = true
        let endPoint : RecipeEndPoints = .allSaveRecipiesBelongsToUser
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[RecipeModel]>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            
            self.allRecipesByUser = data.data ?? [RecipeModel]()
            self.recipesToShow = self.allRecipesByUser
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    
}

extension RecipeViewModel{
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
}

extension RecipeViewModel{
    
    
    func setIngredient(){
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
        //        recipe.minutes += "Mins"
        recipe.userID = user_id
        recipe.ingredients = self.recipeIngredientS
        recipe.carbohydrates = "\(self.carbohydrates)"
        recipe.fats = "\(self.fats)"
        recipe.protein = "\(self.protein)"
        recipe.addedBy = "user"
        self.recipe.foodCategory = "2"
        
        let selectedPreferenceIds = preferenceOptions
            .filter { selectedPreferencesNames.contains($0.name) }
            .compactMap { String($0.id) }

        recipe.foodPreferences = selectedPreferenceIds
        
        
    }
    
    
    func setIngredientForEditRecipe(recipeID : String){
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
        self.recipe.foodCategory = "2"
//        self.recipe.foodPreference = "\(selectedPreferenceId ?? 0)"
        
        let selectedPreferenceIds = preferenceOptions
            .filter { selectedPreferencesNames.contains($0.name) }
            .compactMap { String($0.id) }

        recipe.foodPreferences = selectedPreferenceIds
        
        self.recipe.recipeID = recipeID
        
        
    }
    
    func validateRecipe() -> Bool{
        setIngredient()
        
        if recipe.name.isEmpty{
            showError(message: "Name field is required!")
            return false
        }
        if recipe.minutes.isEmpty{
            showError(message: "Duration field is required!")
            return false
        }
        if let duration = Int(recipe.minutes), duration < 5 {
            showError(message: "Duration cannot be less than 5 minutes")
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
        if recipe.foodPreferences.isEmpty{
            showError(message: "Preference is not selected!")
            return false
        }
        if recipe.foodCategory.isEmpty{
            showError(message: "Recipe category is not selected!")
            return false
        }
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
        
        if recipe.method.isEmpty {
            showError(message: "Instructions are not filled out!")
            return false
        }
        
        if recipe.ingredients.isEmpty {
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
    
    
    
    func setEditRecipeDetails(){
        recipe.name = recipeDetail?.name ?? ""
        //        recipe.ingredients = recipeDetail.ingredients
        recipe.minutes = recipeDetail?.minutes ?? ""
        recipe.difficulty = recipeDetail?.difficulty ?? ""
        recipe.serves = recipeDetail?.serves ?? ""
        let selectedPreferenceIds = preferenceOptions
            .filter { selectedPreferencesNames.contains($0.name) }
            .compactMap { String($0.id) }

        recipe.foodPreferences = selectedPreferenceIds
        
//        selectedPreferenceId = recipeDetail?.foodPreference.id ?? -1
        //        selectedRecipeCategory = recipeDetail.fo
        carbohydrates = Double(recipeDetail?.carbohydrates ?? "0.0") ?? 0.0
        fats = Double(recipeDetail?.fats ?? "0.0") ?? 0.0
        protein = Double(recipeDetail?.protein ?? "0.0") ?? 0.0
        recipe.calories = recipeDetail?.calories ?? ""
        recipe.method = recipeDetail?.method ?? ""
        self.recipeIngredients = recipeDetail?.ingredients ?? [Ingredient]()
        
        
        
    }
    
    func validateEditRecipe(recipeID: String) -> Bool{
        setIngredientForEditRecipe(recipeID: recipeID)
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



