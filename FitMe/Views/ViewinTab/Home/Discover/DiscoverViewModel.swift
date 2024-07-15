//
//  DiscoverViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 20/12/2023.
//

import Foundation

class DiscoverViewModel: FitMeBaseViewModel {
    
    @Published var recipes: [RecipeModel] = []
    @Published var searchedRecipes: [RecipeModel] = []
    @Published var allRecipes: [RecipeModel] = []
    @Published var searchText = ""
    
    // MARK: 0 Filter
    
    var dislikeState = "On"
    @Published var disklikeSelection = "On"
    @Published var sortBy = "Proteins"
    @Published var orderedBy = "High-Low"
    
    // MARK: 1 Configuration
    private let itemsFromEndThreshold = 5
    
    // MARK: 2 API Pagination data
    private var totalItemsAvailable = 0
    private var itemsLoadedCount = 0
    private var page = 1
}

// MAKR: Custom Funstion extesnion
extension DiscoverViewModel {
    
    func searchCancelCalled() {
        recipes = sortRecipe(recipes: allRecipes)
    }
    
    @MainActor func updateSort() async {
        //        check either we need to call the api or not
        if dislikeState != disklikeSelection {
            allRecipes = []
            await requestInitialAppointmentHistory()
            dislikeState = disklikeSelection
        } else {
            recipes = sortRecipe(recipes: allRecipes)
        }
    }
    
    
//    func sortRecipe(recipes: [RecipeModel]) -> [RecipeModel] {
//        var sortedRecipes = recipes
//        
//        switch sortBy {
//        case "Proteins":
//            sortedRecipes.sort(by: { orderedBy == "High-Low" ? Double($0.protein) ?? 0.0 > Double($1.protein) ?? 0.0 : Double($0.protein) ?? 0.0 < Double($1.protein) ?? 0.0})
//        case "Calories":
//            sortedRecipes.sort(by: { orderedBy == "High-Low" ? Double($0.calories) ?? 0.0 > Double($1.calories) ?? 0.0 : Double($0.calories) ?? 0.0 < Double($1.calories) ?? 0.0 })
//        case "Fats":
//            sortedRecipes.sort(by: { orderedBy == "High-Low" ? Double($0.fats) ?? 0.0 > Double($1.fats) ?? 0.0 : Double($0.fats) ?? 0.0 < Double($1.fats) ?? 0.0 })
//        case "Carbs":
//            sortedRecipes.sort(by: { orderedBy == "High-Low" ? Double($0.carbohydrates) ?? 0.0 > Double($1.carbohydrates) ?? 0.0 : Double($0.carbohydrates) ?? 0.0 < Double($1.carbohydrates) ?? 0.0 })
//        default:
//            break
//        }
//        
//        return sortedRecipes
//    }
   
    func sortRecipe(recipes: [RecipeModel]) -> [RecipeModel] {
        var sortedRecipes = recipes



        // Calculate percentages and sort by the specified nutrient
        switch sortBy {
        case "Proteins":
            sortedRecipes.sort(by: {
                let percentage1 = calculatePercentage($0.protein, ((Double($0.protein) ?? 0.0) + (Double($0.carbohydrates) ?? 0.0) + (Double($0.fats) ?? 0.0)))
                let percentage2 = calculatePercentage($1.protein, ((Double($1.protein) ?? 0.0) + (Double($1.carbohydrates) ?? 0.0) + (Double($1.fats) ?? 0.0)))
                return orderedBy == "High-Low" ? percentage1 > percentage2 : percentage1 < percentage2
            })
        case "Calories":
            sortedRecipes.sort(by: {
                return orderedBy == "High-Low" ? Double($0.calories) ?? 0.0 > Double($1.calories) ?? 0.0 : Double($0.calories) ?? 0.0 < Double($1.calories) ?? 0.0
            })
        case "Fats":
            sortedRecipes.sort(by: {
                let percentage1 = calculatePercentage($0.fats, ((Double($0.protein) ?? 0.0) + (Double($0.carbohydrates) ?? 0.0) + (Double($0.fats) ?? 0.0)))
                let percentage2 = calculatePercentage($1.fats, ((Double($1.protein) ?? 0.0) + (Double($1.carbohydrates) ?? 0.0) + (Double($1.fats) ?? 0.0)))
                return orderedBy == "High-Low" ? percentage1 > percentage2 : percentage1 < percentage2
            })
        case "Carbs":
            sortedRecipes.sort(by: {
                let percentage1 = calculatePercentage($0.carbohydrates, ((Double($0.protein) ?? 0.0) + (Double($0.carbohydrates) ?? 0.0) + (Double($0.fats) ?? 0.0)))
                let percentage2 = calculatePercentage($1.carbohydrates, ((Double($1.protein) ?? 0.0) + (Double($1.carbohydrates) ?? 0.0) + (Double($1.fats) ?? 0.0)))
                return orderedBy == "High-Low" ? percentage1 > percentage2 : percentage1 < percentage2
            })
        default:
            break
        }

        return sortedRecipes
    }

    func calculatePercentage(_ nutrient: String, _ totalCalories: Double) -> Double {
        let nutrientValue = Double(nutrient) ?? 0.0
        return (nutrientValue / totalCalories) * 100.0
    }


    
    
}

// MARK: Pagination Extension
extension DiscoverViewModel {
    
    // 1
    func requestInitialAppointmentHistory() async {
        
        page = 1
        await requestDiscoverReciepes(page: page)
    }
    
    // 2
    /// Used for infinite scrolling. Only requests more items if pagination criteria is met.
    func requestMoreItemsIfNeeded(index: Int) async {
        
        if thresholdMeet(itemsLoadedCount, index) &&
            moreItemsRemaining(itemsLoadedCount, totalItemsAvailable) {
            // Request next page
            page += 1
            await requestDiscoverReciepes(page: page)
        }
    }
    
    //4
    /// Determines whether we have meet the threshold for requesting more items.
    private func thresholdMeet(_ itemsLoadedCount: Int, _ index: Int) -> Bool {
        return (itemsLoadedCount - index) == itemsFromEndThreshold
    }
    
    //5
    /// Determines whether there is more data to load.
    private func moreItemsRemaining(_ itemsLoadedCount: Int, _ totalItemsAvailable: Int) -> Bool {
        return itemsLoadedCount < totalItemsAvailable
    }
    
}



extension DiscoverViewModel: NetworkManagerService {
    
    @MainActor private func requestDiscoverReciepes(page: Int) async {
        self.allRecipes.removeAll()
        self.showLoader = true
        let endPoint : HomeEndPoint = .discoverRecipes(page: 1, disklike: disklikeSelection == "On" ? true : false)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[RecipeModel]>.self)
        showLoader = false
        
        switch request {
            
        case .success(let data):
            
            if data.status ?? false {
                //                allAppointments = data.data ?? []
                allRecipes.append(contentsOf: data.data ?? [])
                
                //                pagination variables
                itemsLoadedCount = allRecipes.count
                recipes = sortRecipe(recipes: allRecipes)
                totalItemsAvailable = Int(data.message?.split(separator: "-").first ?? "0") ?? 0
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            self.showError(message: error.customMessage)
        }
        
        
    }
    
    @MainActor  func requestSearchRecipes() async {
        
        let endPoint : HomeEndPoint = .searchRecipe(searchText: searchText)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[RecipeModel]>.self)
        
        switch request {
            
        case .success(let data):
            
            if data.status ?? false {
                searchedRecipes = data.data ?? []
                recipes = searchedRecipes
            } else {
                recipes = []
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            self.showError(message: error.customMessage)
        }
        
    }
    
    @MainActor func saveRecipe(index: Int, isSaved: Bool) async -> Bool {
        
        let selectedRecipe = recipes[index]
        self.showLoader = true
        let endPoint : HomeEndPoint = .saveOrUnsaveRecipe(recipe_id: selectedRecipe.id, isSaved: isSaved)
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
    
}
