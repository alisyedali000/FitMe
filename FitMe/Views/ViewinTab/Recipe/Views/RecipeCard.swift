//
//  RecipeCard.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 19/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecipeCard: View {
    
    var recipe: RecipeModel
    
    var body: some View {
        loadView
    }
}

extension RecipeCard {
    var loadView: some View {
        VStack{
            
            WebImage(url: URL(string: AppUrl.IMAGEURL + (recipe.image)))
                .resizable()
                .indicator(.activity)
                .scaledToFill()
                .frame(width:166, height: 207)
                .clipped()
                .clipShape(.rect)
                .cornerRadius(10.16).overlay(
                    
                    VStack{
                        Spacer()
                        RoundedRectangle(cornerRadius: 5).frame(height: 39)
                            .foregroundColor(.black)
                            .opacity(0.3)
                            .padding(.bottom)
                        
                        
                            .padding(.horizontal,10).overlay(
                                HStack{
                                    VStack(alignment: .leading){
                                        HStack{
                                            Text(recipe.name)
                                                .font(.sansMedium(size: 10))
                                                .foregroundColor(.white)
                                            //                                                            .padding(.horizontal,30)
                                            Spacer()
                                            Text("\(recipe.calories ) Kcal")
                                                .font(.sansRegular(size: 11))
                                                .foregroundStyle(Color.white)
                                                .padding(.trailing,15)
                                        }
                                        
                                        Text("Serves \(recipe.serves ) | \(recipe.minutesValue ?? 0) Mins")
                                            .font(.sansRegular(size: 8))
                                            .foregroundStyle(Color.white)
                                    }
                                    
                                    
                                    
                                    
                                }.padding(.leading,20).padding(.bottom,13)
                                
                            )
                    }
                    
                )
            
        }
    }
}



#Preview {
    RecipeCard(recipe: mockRecipes.first!)
}
