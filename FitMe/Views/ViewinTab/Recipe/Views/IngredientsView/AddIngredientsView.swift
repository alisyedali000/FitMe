//
//  AddIngredientsView.swift
//  FitMe
//
//  Created by Ali Syed on 08/12/2023.
//

import SwiftUI

struct AddIngredientsView: View {
    
    @ObservedObject var dVM : DietPreferencesViewModel
    @State var isExpanded: Bool = false
    @Binding var shouldReload : Bool
    @Binding var recipeIngredients: [Ingredient]
    var body: some View {
        ZStack{
            screenView()
            LoaderView(isLoading: $dVM.showLoader)
        }.navigationTitle("Add Ingredients").toolbarRole(.editor)
        .onAppear() {
            Task {
                await dVM.getFoodCategories()
                self.shouldReload = false
            }
        }
    }
}

extension AddIngredientsView {
    
    func screenView() -> some View{
        ScrollView{
            VStack {
                
                searchNavigationLink
                
                ForEach(dVM.foodCategories, id: \.self) { category in
                    VStack {
                        HStack {
                            Text(category.name)
                                .font(.sansMedium(size: 18))
                            Spacer()
                            let count = dVM.countSelectedItems(for: category)
                            if count > 0 {
                                Text("\(count)")
                                    .font(.sansRegular(size: 12))
                                    .foregroundStyle(.white)
                                    .background(
                                        Circle()
                                            .frame(width: 18, height: 18)
                                            .foregroundStyle(Color.redColor)
                                    )
                                    .padding(.horizontal)
                            }
                            Image(systemName: isExpanded && dVM.selectedCategory == category ? "chevron.down" : "chevron.right")
                                .rotationEffect(.degrees(isExpanded && dVM.selectedCategory == category ? 1 : 0))
                        }
                        .onTapGesture {
                            withAnimation {
                                if dVM.selectedCategory == category {
                                    isExpanded.toggle()
                                } else {
                                    isExpanded = true
                                    dVM.selectedCategory = category
                                    Task {
                                        await dVM.getFoodDislikes()
                                        preselection()
                                    }
                                }
                            }
                        }
                        
                        if isExpanded && dVM.selectedCategory == category {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(dVM.foodDislikes, id: \.self) { food in
                                    if food.foodCategoryID == "\(category.id)" {
                                        TagSelection(title: food.name, isSelected: dVM.selectedDislikedFoods.contains(food))
                                            .onTapGesture {
                                                if let dislikedFood = dVM.selectedDislikedFoods.firstIndex(of: food) {
                                                    dVM.selectedDislikedFoods.remove(at: dislikedFood)
                                                    recipeIngredients = recipeIngredients.filter { $0.id != food.id }
                                                } else {
                                                    let ingredient = Ingredient(id: food.id , name: food.name , quantity: "", scale: "")
                                                    recipeIngredients.append(ingredient)
                                                    dVM.selectedDislikedFoods.append(food)
                                                }
                                            }
                                    }
                                }
                            }.padding(.bottom, isExpanded ? 10 : 0)
                        }
                    }
                    Divider().offset(y: -10)
                }
            }
            .padding(.horizontal)
        }
    }
    
    var searchNavigationLink: some View {
        NavigationLink {
            AddIngridentSearchView(viewModel: dVM, recipeIngredients: $recipeIngredients)
        } label: {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.black.opacity(0.30))
                    .opacity(0.20)
                    .frame(height: 50)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding([.leading])
                    Text("Search")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
    
    
    
    func preselection() {
        for ingredient in recipeIngredients {
            if let matchedFood = dVM.foodDislikes.first(where: { $0.id == ingredient.id }) {
                if !dVM.selectedDislikedFoods.contains(matchedFood){
                    dVM.selectedDislikedFoods.append(matchedFood)
                }
            }
        }
    }
    func getAllFoods(){

    }
}

#Preview {
    AddIngredientsView(dVM: DietPreferencesViewModel(), shouldReload: .constant(false), recipeIngredients: .constant([]))
}
