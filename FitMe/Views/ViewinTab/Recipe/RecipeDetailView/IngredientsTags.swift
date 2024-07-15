//
//  IngredientsTags.swift
//  FitMe
//
//  Created by Ali Syed on 13/12/2023.
//

import SwiftUI

struct IngredientsTags: View {
    @Binding var details : RecipeModel
    @State var width = CGFloat.zero
    @State var height = CGFloat.zero
    @Binding var totalHeight : CGFloat
    
    
    var body: some View {
        
            ZStack(alignment: .topLeading){
                
                    ForEach(details.ingredients, id:\.self) { ingredient in
                        let quantity = Double(ingredient.quantity ) ?? 0.0
                        Text("\(Int(quantity)) \(ingredient.scale ?? "") \(ingredient.name )").padding(.horizontal,10).padding(.vertical,10)
                            .font(.sansRegular(size: 14))
                            .foregroundStyle(Color.grayImages)
                            .background(
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(Color.textfieldBackground)
                            )
                            .padding([.leading, .bottom])
                            .alignmentGuide(.leading, computeValue: { d in
                                if abs(width - d.width) > UIScreen.main.bounds.size.width {
                                    width = 0
                                    height -= d.height
                                }
                                let result = width
                                if ingredient == self.details.ingredients.last! {
                                    width = 0 // last item
                                } else {
                                    width -= d.width
                                }
                                return result
                            })
                            .alignmentGuide(.top, computeValue: {_ in
                                let result = height
                                if ingredient == self.details.ingredients.last! {
                                    height = 0 // last item
                                }
                                return result
                            })
                    }
                
            
        }.background(
            viewHeightReader($totalHeight)
            
        )
    }
}
extension IngredientsTags{
    func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}
#Preview {
    IngredientsTags(details: .constant(mockRecipes.first!), totalHeight: .constant(0.0))
}
