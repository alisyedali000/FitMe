//
//  MealHistoryViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 29/12/2023.
//

import Foundation

class MealHistoryViewModel: FitMeBaseViewModel {
    
    @Published var selecteDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    
    @Published var breakfast: [RecipeModel] = []
    @Published var lunch: [RecipeModel] = []
    @Published var dinner: [RecipeModel] = []
    @Published var snacks: [RecipeModel] = []
}

// MARK: Network manage
extension MealHistoryViewModel: NetworkManagerService {
    @MainActor func requestMealHistory() async {

        let strDate = DateManager.shared.getDobString(from: selecteDate)
        
        self.showLoader = true
        let endPoint : MealPlanEndPoint = .mealHistory(date: strDate)
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
}
