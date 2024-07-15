//
//  EditIngredietnsView.swift
//  FitMe
//
//  Created by Ali Syed on 14/12/2023.
//

import SwiftUI
//
//  AddIngredientsView.swift
//  FitMe
//
//  Created by Ali Syed on 08/12/2023.
//

import SwiftUI

struct EditIngredientsView: View {
    @ObservedObject var rVM : RecipeViewModel
    @ObservedObject var dVM : DietPreferencesViewModel
    @State var isExpanded: Bool = false
    
    var body: some View {
        ScrollView{
            VStack {
                ForEach(dVM.foodCategories, id: \.self) { category in

                    VStack {
                        HStack {
                            Text(category.name ?? "")
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
                                    }
                                }
                            }
                        }
                        
                        if isExpanded && dVM.selectedCategory == category {
                            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                                ForEach(dVM.foodDislikes, id: \.self) { food in
                                    if food.foodCategoryID == "\(category.id )" {
                                        TagSelection(title: food.name, isSelected: dVM.selectedDislikedFoods.contains(food))
                                            .onTapGesture {
                                                if let dislikedFood = dVM.selectedDislikedFoods.firstIndex(of: food) {
                                                    dVM.selectedDislikedFoods.remove(at: dislikedFood)
                                                } else {
                                                    var ingredient = Ingredient(id: food.id , name: food.name , quantity: "", scale: "")
                                                    rVM.recipeIngredients.append(ingredient)
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
        .onAppear() {
            Task {
                await dVM.getFoodCategories()
            }
        }
    }
}

extension EditIngredientsView {
    func customTag(title: String, isSelected: Bool) -> some View {
        VStack {
            Rectangle()
                .foregroundColor(isSelected ? .redColor : .textfieldBackground)
                .frame(minWidth: 140)
                .frame(height: 40)
                .cornerRadius(6)
                .overlay(
                    HStack {
                        Text(title)
                            .font(.sansRegular(size: 15))
                            .foregroundColor(isSelected ? .white : .gray)
                        Spacer()
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circlebadge")
                            .foregroundColor(isSelected ? .white : .grayImages)
                    }
                    .padding(.horizontal, 10)
                )
        }
    }
}

extension EditIngredientsView{

}

#Preview {
    EditIngredientsView(rVM: RecipeViewModel(), dVM: DietPreferencesViewModel())
}
