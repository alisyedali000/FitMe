//
//  DietPreferenceSelectionViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 09/01/2024.
//

import Foundation
class DietPreferenceSelectionViewModel : FitMeBaseViewModel {

    @Published var dietPreferences = [DietPreference]()
    @Published var selectedPreferencesName = [String]()
    
}

extension DietPreferenceSelectionViewModel {
    func getSelectedPreferenceIds() -> [String] {
        
        let selectedPreferenceIds = dietPreferences
            .filter { selectedPreferencesName.contains($0.name) }
            .compactMap { String($0.id) }
        
        return selectedPreferenceIds
    }
    
    @MainActor func updateDitePreferences() async  {
        let selectedPreferenceIds = getSelectedPreferenceIds()
        
        if selectedPreferencesName.count == 0 {
            showError(message: "Please select one preference")
        } else {
            await requestUpdateDietPreference(foodPreferenceIds: selectedPreferenceIds)
        }
    }
}


// Network manager extensino
extension DietPreferenceSelectionViewModel: NetworkManagerService {
    
    @MainActor func getDietPreferences() async {
        
        self.showLoader = true
        let endPoint : DietEndPoints = .dietPreferencesAgainstID
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<[DietPreference]>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            self.dietPreferences = data.data ?? [DietPreference]()
            
            for preference in dietPreferences {
                if preference.isSelected {
                    selectedPreferencesName.append(preference.name)
                }
            }
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
    }
    
    @MainActor func requestUpdateDietPreference(foodPreferenceIds: [String]) async {
        
        self.showLoader = true
        
        let endPoint : DietEndPoints = .updateFoodPreference(foodPreferenceIds: foodPreferenceIds)
        let request = await sendRequest(endpoint: endPoint, responseModel: GenericResponseModel<UserDetails>.self)
        self.showLoader = false
        switch request {
            
        case .success(let data):
            
            debugPrint(data.message ?? "")
            debugPrint(data.status ?? "")
            debugPrint(data.data as Any)
            showError(message: data.message ?? "Update successful")
            
        case .failure(let error):
            debugPrint(error.customMessage)
            showError(message: error.customMessage)
            
        }
        
    }
    
}
