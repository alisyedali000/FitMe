//
//  AuthEndPoints.swift
//  FitMe
//
//  Created by Ali Syed on 01/12/2023.
//

import SwiftUI

struct DietPreferencesAndFoodDislikes: View {
    @ObservedObject var dVM : DietPreferencesViewModel
    @State var showExpaned : Bool

    @State var showDietPref = false
    @State var showFoodDislikes = false
    var body: some View {
        VStack(spacing:20) {
            HStack {
                Text("Diet Preference")
                    .font(.sansMedium(size: 20))
                Spacer()
                
                Image(systemName: showDietPref == true ? "chevron.down" : "chevron.right")
            }.onTapGesture {
                withAnimation {
                    showDietPref.toggle()
                }
                
            }
            if showDietPref{
                
                GenericMultiListSelection(list: dVM.dietPreferences, selectedItems: $dVM.selectedPreferencesName)
                
//                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
//                    ForEach(dVM.dietPreferences, id: \.self) { diet in
//                        TagSelection(title: diet.name, isSelected: diet == dVM.selectedDietPreference)
//                            .onTapGesture {
//                                dVM.selectedDietPreference = diet
//                            }
//                    }
//                }
            }
            
            HStack {
                Text("Food Dislikes")
                    .font(.sansMedium(size: 20))
                Spacer()
                
                Image(systemName: showFoodDislikes == true ? "chevron.down" : "chevron.right")
            }.onTapGesture {
                withAnimation {
                    showFoodDislikes.toggle()
                }
                
            }

            if showFoodDislikes {
                HStack{
                    Text("Select Food Category")
                    Spacer()
                    Menu {
                        ForEach(dVM.foodCategories, id: \.self) { category in
                            Button {
                                dVM.selectedCategory = category
                                Task {
                                    await dVM.getFoodDislikes()
                                }
                            } label: {
                                Text(category.name)
                            }
                        }
                    } label: {
                        Label {
                            Text(dVM.selectedCategory.name)
                        } icon: {
                            Image(systemName: "chevron.down")
                        }
                    }

                }
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                    ForEach(dVM.foodDislikes , id: \.self) { food in
                        TagSelection(title: food.name, isSelected: dVM.selectedDislikedFoods.contains(food))
                        
                            .onTapGesture {
                                if let dislikedFood = dVM.selectedDislikedFoods.firstIndex(of: food) {
                                    dVM.selectedDislikedFoods.remove(at: dislikedFood) // Deselect if already selected
                                } else {
                                    dVM.selectedDislikedFoods.append(food) // Select if not selected
                                }
                            }
                    }
                }
            }
            
            
            Spacer()
        }.onAppear(){
            Task{
                if showExpaned{
                    withAnimation {
                        self.showDietPref = true
                        self.showFoodDislikes = true
                    }

                }
            }
        }
        
    }
}


struct DietPreferencesAndFoodDislikes_Previews: PreviewProvider {
    static var previews: some View {
        DietPreferencesAndFoodDislikes(dVM: DietPreferencesViewModel(), showExpaned: false)
    }
}
