//
//  MealPlannerViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 22/12/2023.
//

import Foundation

class MealPlannerViewModel: FitMeBaseViewModel {
    
    
    @Published var selectedMealTime = TODAY
    @Published var selectedWeekDay = "Monday"

    @Published var breakfast: [RecipeModel] = []
    @Published var lunch: [RecipeModel] = []
    @Published var dinner: [RecipeModel] = []
    @Published var snacks: [RecipeModel] = []
    
    @Published var todayIntake: UserGoal?
    @Published var userGoal = UserDefaultManager.shared.getUserGoal()
    
}

// MARK: Custom Function
extension MealPlannerViewModel {
    
    func getMealDay() -> String {
        
        if selectedMealTime == TODAY {
            return selectedMealTime.lowercased()
        } else {
            return "\(selectedMealTime.lowercased())-\(selectedWeekDay.lowercased())"
        }
    }
    
    func clearMealArrays() {
        breakfast.removeAll()
        lunch.removeAll()
        dinner.removeAll()
        snacks.removeAll()
    }
    
    func updateUserGoal() {
        userGoal = UserDefaultManager.shared.getUserGoal()
    }

}



extension MealPlannerViewModel: NetworkManagerService {
    
    @MainActor func requestDailyMeelPlan() async {
        
        debugPrint("FitMeLog: requestDailyMeelPlan")
        clearMealArrays()
        
        self.showLoader = true
        let endPoint : MealPlanEndPoint = .todayMealPlan
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<MealPlaneModel>.self)
        showLoader = false
        
        switch request {
            
        case .success(let data):
            
            if data.status ?? false {
                breakfast = data.data?.breakfast ?? []
                lunch = data.data?.lunch ?? []
                dinner = data.data?.dinner ?? []
                snacks = data.data?.snacks ?? []
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            self.showError(message: error.customMessage)
        }
        
        
    }
    
    @MainActor func requestWeeklyMeelPlan() async {
        
        debugPrint("FitMeLog: requestWeeklyMeelPlan")

        self.showLoader = true
        let endPoint : MealPlanEndPoint = .weeklyMealPlan(day: selectedWeekDay)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<WeeklyMealPlan>.self)
        showLoader = false
        
        switch request {
            
        case .success(let data):
            
            if data.status ?? false {
                breakfast = data.data?.mealPlan.breakfast ?? []
                lunch = data.data?.mealPlan.lunch ?? []
                dinner = data.data?.mealPlan.dinner ?? []
                snacks = data.data?.mealPlan.snacks ?? []
                todayIntake = data.data?.intake
                
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            self.showError(message: error.customMessage)
        }
        
        
    }
    
}

