//
//  SetGoalViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 27/12/2023.
//

import Foundation

class UpdateGoalViewModel: FitMeBaseViewModel {

    @Published var calories = "" {
        didSet {
            updateGrams()
        }
    }
    
    @Published var carbohydrates = 0 {
           didSet {
               updateGrams()
           }
       }
       @Published var protein = 0 {
           didSet {
               updateGrams()
           }
       }
       @Published var fats = 0 {
           didSet {
               updateGrams()
           }
       }
    
    @Published var carbohydratesInGrams = 0
    @Published var proteinInGrams = 0
    @Published var fatsInGrams = 0
    
    override init() {
        super.init()
        let userGoal = UserDefaultManager.shared.getUserGoal()
        
        calories = userGoal.calories ?? "0"
        carbohydrates = userGoal.carbohydratesPercentage
        protein = userGoal.proteinPercentage
        fats = userGoal.fatsPercentage
        
        self.updateGrams()
    }
    
    var isSumEqualTo100: Bool {
          return (carbohydrates + protein + fats) == 100
      }
    
    var totalSum: Int {
        return (carbohydrates + protein + fats)
    }
    
    private func updateGrams() {
        let caloriesDouble = Double(calories) ?? 0.0
        
        let calories25Percent = caloriesDouble * 0.25
        let calories11Percent = caloriesDouble * 0.11
        debugPrint(calories25Percent * Double(protein) / 100.0)
        
        carbohydratesInGrams = Int(calories25Percent * (Double(carbohydrates) / 100.0))
        proteinInGrams = Int(calories25Percent * (Double(protein) / 100.0))
        fatsInGrams = Int(calories11Percent * (Double(fats) / 100.0))
    }
    
    func updateGoalValidation() -> Bool {
        if calories.isEmpty {
            showError(message: "Please enter valid value for calories")
            return false
        }
            
        return true
    }
    
}

extension UpdateGoalViewModel: NetworkManagerService {
    
    
    @MainActor func updateGoal() async -> Bool {
        if updateGoalValidation() {
            return await requestUpdateUserGoal()
        }
        return false
    }
    
    @MainActor func requestUpdateUserGoal() async -> Bool {
        
        self.showLoader = true
        
        let updatedGoal = UserGoal(
            userID: user_id,
            calories: String(calories),
            carbohydrates: String(carbohydratesInGrams),
            protein: String(proteinInGrams),
            fats: String(fatsInGrams)
        )
        
        let endPoint: HomeEndPoint = .setGoal(userGoal: updatedGoal)
        
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponse.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            if data.status {
//                update value into the user Defaults
                UserDefaultManager.shared.setUserGoal(userGoal: updatedGoal)
                return true
            } else {
                showError(message: data.message)
                return false
            }
            
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            return false
        }
        
        
    }
    
}
