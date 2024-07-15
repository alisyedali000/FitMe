//
//  MealTypeSelectionSheet.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 21/12/2023.
//

import SwiftUI



struct MealTypeSelectionSheet: View {
    
    @Binding var mealTimeSelection: String
    @Binding var mealTypeSelection: String
    @Binding var selectedItems: [String]
    var addMealAction: () -> (Void)
    @Environment (\.presentationMode) var presentationMode
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    
    var body: some View {
        loadView
            .alert(isPresented: $showError, content: {
                        Alert(title: Text(errorMessage))
                    })
    }
}

// MAKR: View extension
extension MealTypeSelectionSheet {
    
    var loadView: some View {
        VStack(spacing: 20) {
            
            Text("Add Meal")
                .font(.sansMedium(size: 16))
            InfoBannerView(text: "You can quickly add your recipe in todays meal plan by selecting - meal time Today")
            mealTime
            
            
            if mealTimeSelection == WEEKLY {
                withAnimation {
                    MultiListSelection(list: WEEKDAYS, selectedItems: $selectedItems)
                }
            }
            
            mealType
            
            CustomButton(title: "Add Meal") {
                if isSelectionValidate() {
                    addMealAction()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            
            CancelButton(title: "Canel") {
                presentationMode.wrappedValue.dismiss()
            }
            
        }.padding()
    }
    
    var mealTime: some View {
        HStack {
            
            Text("Meal Time")
                .font(.sansMedium(size: 16))
            Spacer()
            SingleButtonSelection(categories: ["Today", "Weekly"], selection: $mealTimeSelection)
        }
    }
    
    var mealType: some View {
        VStack(alignment: .leading) {
            
            Text("Meal Type")
                .font(.sansMedium(size: 16))
            HStack {
                SingleButtonSelection(categories: ["Breakfast", "Lunch", "Dinner", "Snacks"], selection: $mealTypeSelection)
                Spacer()
            }
            
        }
    }

}
// MARK: Custom Function
extension MealTypeSelectionSheet {
    
//     it would be greate if we will add these kind of stuff in view models. But this is independent module
    func isSelectionValidate() -> Bool {
     
        if mealTimeSelection.isEmpty {
            showErrorAlert(message: "Please select meal time")
            return false
        }
        
        if (mealTimeSelection == WEEKLY) && (selectedItems.isEmpty) {
            showErrorAlert(message: "Please select day(s) of week")
            return false
        }
        
        if mealTypeSelection.isEmpty {
            showErrorAlert(message: "Please select meal type")
            return false
        }
        
        return true
    }
    
    func showErrorAlert(message: String) {
        errorMessage = message
        showError.toggle()
    }
    
}


#Preview {
    MealTypeSelectionSheet(mealTimeSelection: .constant(WEEKLY), mealTypeSelection: .constant("Breakfast"), selectedItems: .constant(["Friday"]), addMealAction:{
        
    })
}
