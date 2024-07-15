//
//  DislikeSelectionViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 09/01/2024.
//

import Foundation

class DislikeSelectionViewModel: FitMeBaseViewModel {
    
    @Published var selectedCategory = FoodCategories()
    @Published var selectedDislikedFoods = [FoodDislikes]()
    
    @Published var foodDislikes = [FoodDislikes]()
    @Published var foodCategories = [FoodCategories]()
    
//    Search Feature
//    @Published var userDislikedFood = [FoodDislikes]()
    @Published var ingridentSearchText = ""
    @Published var filteredDislikeFood = [FoodDislikes]()
    
}

// MARK: Custom function extension
extension DislikeSelectionViewModel {
    func updateSelectedDislikedFoods(with filteredFoods: [FoodDislikes]) {
        for food in filteredFoods {
            if !selectedDislikedFoods.contains(where: { $0.name == food.name }) && food.isSelected {
                selectedDislikedFoods.append(food)
            }
        }
    }
}


// MARK: Network manager extension

extension DislikeSelectionViewModel: NetworkManagerService {
    
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
        let endPoint : DietEndPoints = .foodDislikesAgainstID(food_category_id: "\(selectedCategory.id)")
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[FoodDislikes]>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            
            self.foodDislikes = data.data ?? [FoodDislikes]()
            
//            updateSelectedDislikedFoods(with: foodDislikes)
            
            
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
            
            self.foodDislikes = data.data ?? [FoodDislikes]()
            
            
//            updateSelectedDislikedFoods(with: filteredDislikeFood)
            
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
    }
    
    
    @MainActor func setFoodDislikes() async {
        
        debugPrint("setFoodDislikes is called")
        self.showLoader = true
        var selectedIDs = [String]()
        
        for food in selectedDislikedFoods {
            selectedIDs.append(String(describing: food.id))
        }
        
        let endPoint : DietEndPoints = .updateFoodDislike(dislikeFoodIds: selectedIDs)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            self.selectedDislikedFoods = data.data?.foodDislikes ?? [FoodDislikes]()
            UserDefaultManager.shared.set(user: data.data)
            showError(message: data.message ?? "")
            
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
    }
    
    
    
    
}
