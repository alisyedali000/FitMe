//
//  SetGoalViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 27/12/2023.
//

import Foundation

class GoalViewModel: FitMeBaseViewModel {
    
    @Published var goalHistory: GoalHistory?
    
    @Published var startDate: String = DateManager.shared.getCurrentWeekStartEndDate().startDate
    @Published var endDate: String = DateManager.shared.getCurrentWeekStartEndDate().endDate
    
    @Published var calories = ""
    
    @Published var carbohydratesInGrams = 0
    @Published var proteinInGrams = 0
    @Published var fatsInGrams = 0
    
    @Published var carbohydratesPercentage = 0
    @Published var proteinPercentage = 0
    @Published var fatsPercentage = 0
    
    
}

// Custom function extension
extension GoalViewModel {
    func calculateGoalPercentages() {
        
        let userGoal =  UserDefaultManager.shared.getUserGoal()
        calories = userGoal.calories ?? ""
        
        carbohydratesInGrams = userGoal.carbohydratesInt
        proteinInGrams = userGoal.proteinInt
        fatsInGrams = userGoal.fatsInt
        
        
        carbohydratesPercentage = userGoal.carbohydratesPercentage
        proteinPercentage = userGoal.proteinPercentage
        fatsPercentage = userGoal.fatsPercentage
        
        
    }
}


// MARK: Network extension
extension GoalViewModel: NetworkManagerService {
    
    @MainActor func requestGoalHistory() async  {
        
        self.showLoader = true
        
        let startDate = DateManager.shared.convertDateFormat(inputDateString: startDate, inputFormat: "dd MMM, yyyy", outputFormat: "dd-MM-yyyy") ?? ""
        let endDate = DateManager.shared.convertDateFormat(inputDateString: endDate, inputFormat: "dd MMM, yyyy", outputFormat: "dd-MM-yyyy") ?? ""
        
        let endPoint: HomeEndPoint = .userGoalHistory(startDate: startDate, endDate: endDate)
        
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<GoalHistory>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            if data.status ?? false {
                goalHistory = data.data
            } else {
                showError(message: data.message ?? "")
            }
            
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
        
    }
    
}
