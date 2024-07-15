//
//  HomeViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 27/12/2023.
//

import Foundation

class HomeViewModel: FitMeBaseViewModel {
    
    @Published var userGoal: UserGoal?
    @Published var todayIntake: UserGoal?
    @Published var todayRecips = [RecipeModel]()
    
    func updateGoal() {
        userGoal = UserDefaultManager.shared.getUserGoal()
    }
    
}

extension HomeViewModel: NetworkManagerService {
    @MainActor  func fetchHomeData() async {

        todayRecips = []
        
        self.showLoader = true
        let endPoint : HomeEndPoint = .fitmeHome
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<HomeModel>.self)
        showLoader = false
        switch request {
            
        case .success(let data):
            
            if data.status ?? false {
                
                todayRecips += mapRecipesWithMealType(recipes: data.data?.todayMealPlan.breakfast, mealType: BREAKFAST.lowercased())
                todayRecips += mapRecipesWithMealType(recipes: data.data?.todayMealPlan.lunch, mealType: LUNCH.lowercased())
                todayRecips += mapRecipesWithMealType(recipes: data.data?.todayMealPlan.snacks, mealType: SNACKS.lowercased())
                todayRecips += mapRecipesWithMealType(recipes: data.data?.todayMealPlan.dinner, mealType: DINNER.lowercased())

                
                userGoal = data.data?.userGoal
                todayIntake = data.data?.todayIntake
                
                
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            self.showError(message: error.customMessage)
        }
        
    }
    
    func mapRecipesWithMealType(recipes: [RecipeModel]?, mealType: String) -> [RecipeModel] {
        return recipes?.map { recipe in
            var updatedRecipe = recipe
            updatedRecipe.mealType = mealType
            return updatedRecipe
        } ?? []
    }
    
}
