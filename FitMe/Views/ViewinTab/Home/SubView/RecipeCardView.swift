//
//  RecipeCardView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 20/12/2023.
//

import SwiftUI

struct RecipeCardView: View {
    
    @Binding var recipe: RecipeModel
    var saveAction: (Bool) -> ()
    
    var body: some View {
        loadView
    }
}

extension RecipeCardView {
    
    var loadView: some View {
        ZStack {
            RectangleAysnImageView(url: recipe.image)
                .scaledToFill()
                .frame(width: (UIScreen.main.bounds.size.width/2) - 35 ,
                       height: ((UIScreen.main.bounds.size.width/2)) * 1.2)
            
            VStack {
                HStack {
                    saveButtonView
                    Spacer()
                }.padding([.leading, .top], 10)
                
                Spacer()
                
                bottomDetails
            }
            .foregroundStyle(.white)
            
        }.cornerRadius(10, corners: .allCorners)
    }
    
    var saveButtonView: some View {
        
        Button(action: {
            saveAction(!recipe.saved)
        }, label: {
            Image(recipe.saved ? "save.fill" : "save")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .padding(7)
                .background(
                    BlurCircle()
                )
        })
        
    }
    
    var bottomDetails: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(recipe.name)
                    .font(.sansMedium(size: 12))
                    .lineLimit(1)
                Spacer()
                Text("\(recipe.calories) Kcal")
                    .font(.sansRegular(size: 10))
            }
            Text("Serves \(recipe.serves) | \(recipe.minutes) min")
                .font(.sansRegular(size: 10))
        }
        .padding(5)
        .background(
            BlurRectangle()
            
        )
        .padding(10)
    }
    
}


#Preview {
    RecipeCardView(recipe: .constant(mockRecipes.first!), saveAction: {_ in 
        
    })
    .frame(width: 166, height: 207)
}
