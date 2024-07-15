//
//  AddIngridentSearchView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 10/01/2024.
//

import SwiftUI

struct AddIngridentSearchView: View {
    
    @ObservedObject var viewModel: DietPreferencesViewModel
    @Binding var recipeIngredients: [Ingredient]
    
    var body: some View {
        loadView
            .onReceive(viewModel.$ingridentSearchText, perform: { _ in
                Task {
                    await viewModel.searchFoodDislikes()
                }
            })
            .navigationTitle("Search Ingrident")
            .toolbarRole(.editor)
    }
}


extension AddIngridentSearchView {
    
    var loadView: some View {
        ScrollView {
            VStack {
                SearchBar(text: $viewModel.ingridentSearchText) {
                    viewModel.ingridentSearchText = ""
                }
                
                if viewModel.ingridentSearchText.isEmpty {
                    emptyView
                } else {
                    listView
                }
            }
        }.padding()
        
    }
    
    
    var listView: some View {
        
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            ForEach(viewModel.filteredDislikeFood, id: \.self) { food in
                TagSelection(title: food.name, isSelected: viewModel.selectedDislikedFoods.contains(food))
                    .onTapGesture {
                        if let dislikedFood = viewModel.selectedDislikedFoods.firstIndex(of: food) {
                            viewModel.selectedDislikedFoods.remove(at: dislikedFood)
                            recipeIngredients = recipeIngredients.filter { $0.id != food.id }
                        } else {
                            let ingredient = Ingredient(id: food.id , name: food.name , quantity: "", scale: "")
                            recipeIngredients.append(ingredient)
                            viewModel.selectedDislikedFoods.append(food)
                        }
                    }
            }
        }
        
        
    }
    
    var emptyView: some View {
        Text("Please type to search ingredients")
            .font(.sansMedium(size: 16))
    }
}

#Preview {
    AddIngridentSearchView(viewModel: DietPreferencesViewModel(), recipeIngredients: .constant([]))
}
