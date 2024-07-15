//
//  MealTypeList.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 22/12/2023.
//

import SwiftUI

struct MealTypeWithRecipesList: FitMeBaseView {
    
    let title: String
    var mealDay: String
    @Binding var recipes: [RecipeModel]
    var addAction: (String) -> (Void)
    
    var body: some View {
        loadView
    }
}

extension MealTypeWithRecipesList {
    
    var loadView: some View {
        VStack(spacing: 5) {
            mealtitle
            if recipes.isEmpty {
                emptyListView
            } else {
                recipesList
            }
            
        }
        
    }
    
    var mealtitle: some View {
        HStack {
            Text(title)
                .font(.sansMedium(size: 16))
            Spacer()
        
        }
    }
    
    var recipesList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Array(recipes.enumerated()), id: \.element.id) { index, element in
                    
                    NavigationLink {
                        RecipeDetailView(recipe: $recipes[index], isComeFromMealPlan: true, mealType: title.lowercased(), mealDay: mealDay)
                    } label: {
                        RecipeCardHome(recipe: $recipes[index], width: 170, height: 210)
                            .padding(5)
                            .frame(width: 170, height: 210)
                    }
                }
            }
        }
    }
    
    var emptyListView: some View {
        VStack(spacing: 10) {
            
            Image("emptyListView")
                .resizable()
                .frame(width: 130, height: 107)
                .scaledToFit()
            
            Text("You have not added any recipe in \(title)")
                .font(.sansMedium(size: 13))
        }
    }
    
}

#Preview {
    MealTypeWithRecipesList(title: BREAKFAST, mealDay: "weekly-monday", recipes: .constant(mockRecipes)) { _ in
        
    }
}
