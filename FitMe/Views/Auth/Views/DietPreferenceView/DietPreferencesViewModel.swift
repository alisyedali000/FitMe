//
//  DietPreferencesViewModel.swift
//  FitMe
//
//  Created by Ali Syed on 04/12/2023.
//

import Foundation
class DietPreferencesViewModel : FitMeBaseViewModel {

    @Published var dietPreferences = [DietPreference]()
    @Published var foodCategories = [FoodCategories]()
    @Published var foodDislikes = [FoodDislikes]()
    
    @Published var allFoods = [FoodDislikes]()
    
    @Published var selectedDietPreference = DietPreference()
    @Published var selectedPreferencesName = [String]()
    
    @Published var selectedDislikedFoods = [FoodDislikes]()
    @Published var selectedCategory = FoodCategories()
    @Published var screenSelection = "Diet Preferences"
    
//    Dislike Food Attribute
    @Published var ingridentSearchText = ""
    @Published var filteredDislikeFood = [FoodDislikes]()

}

extension DietPreferencesViewModel {
    func getSelectedPreferenceIds() -> [String] {
        
        let selectedPreferenceIds = dietPreferences
            .filter { selectedPreferencesName.contains($0.name) }
            .compactMap { String($0.id) }
        
        return selectedPreferenceIds
    }
}


extension DietPreferencesViewModel:NetworkManagerService {
    
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
            self.dietPreferences = data.data ?? [DietPreference]()
            
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
            self.foodCategories = data.data ?? [FoodCategories]()
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
    @MainActor func getFoodDislikes() async {
        
        self.showLoader = true
        let endPoint : DietEndPoints = .foodDislikes(food_category_id: "\(selectedCategory.id)")
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[FoodDislikes]>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            self.foodDislikes = data.data ?? [FoodDislikes]()
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
    }
    
    @MainActor func searchFoodDislikes() async {
        
        filteredDislikeFood = []
        self.showLoader = true
        let endPoint : DietEndPoints = .searchDislike(searchText: ingridentSearchText)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[FoodDislikes]>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            
            self.filteredDislikeFood = data.data ?? [FoodDislikes]()
            
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
    }
    
}
    
extension DietPreferencesViewModel{
    func countSelectedItems(for category: FoodCategories) -> Int {
        let selectedItems = self.selectedDislikedFoods.filter { food in
            food.foodCategoryID == "\(category.id )"
        }
        return selectedItems.count
    }
}
