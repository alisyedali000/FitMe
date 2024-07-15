//
//  RecipeCardHome.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 19/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeCardHome: FitMeBaseView {
    
    @Binding var recipe: RecipeModel
    var width: Double
    var height: Double
    
    
    var body: some View {
        loadView
    }
}

extension RecipeCardHome {
    
    var loadView: some View {
        ZStack {
            RectangleAysnImageView(url: recipe.image)
                .scaledToFill()
                .frame(width: width, height: height)
            
            VStack {
                HStack {
                    eatenView
                    skippedView
                    Spacer()
                }.padding([.leading, .top])

                Spacer()
                
                bottomDetails
            }
            .foregroundStyle(.white)
  
        }.cornerRadius(10, corners: .allCorners)
    }
    
    var eatenView: some View {
        HStack{
            Image(systemName: recipe.foodEaten == 1 ?
            "checkmark.circle.fill" : "checkmark.circle")
                .resizable()
                .frame(width: 10, height: 10)
            Text("Eaten")
                .font(.sansRegular(size: 10))
        }.padding(4)
        .background(
            BlurRectangle()
        )
    }
    
    var skippedView: some View {
        HStack{
            Image(systemName: recipe.foodSkipped == 1 ? "multiply.circle.fill" : "multiply.circle" )
                .resizable()
                .frame(width: 10, height: 10)
            Text("Skipped")
                .font(.sansRegular(size: 10))
        }.padding(4)
        .background(
            BlurRectangle()
        )
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
    RecipeCardHome(recipe: .constant(mockRecipes.first!), width: 150, height: 150)
        .frame(width: 200, height: 240)
}
