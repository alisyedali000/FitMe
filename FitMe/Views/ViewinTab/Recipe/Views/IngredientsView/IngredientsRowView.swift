//
//  IngredientsRowView.swift
//  FitMe
//
//  Created by Ali Syed on 22/01/2024.
//
import SwiftUI
struct IngredientRowView: View {
    @Binding var ingredient: Ingredient
    @State var scale: String = "" // Local state to handle scale changes
    @State var portion = Portion.none.rawValue
    var crossAction: () -> (Void)

    var body: some View {
        HStack {
            Text(ingredient.name)
                .font(.sansRegular(size: 14))
            Spacer()
                    HStack {
                        TextField("No.", text: Binding(
                            get: { ingredient.quantity },
                            set: { newValue in
                                ingredient.quantity = newValue.isEmpty ? "" : newValue
                            }
                        ))
                        .frame(width: 40)
                        .font(.sansRegular(size: 12))
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                        
                        Spacer()
                        scaleMenu()
                        portionMenu()
                    }.background(
                        RoundedRectangle(cornerRadius: 4.62)
                            .foregroundStyle(Color.textfieldBackground)
                            .frame(height: 30)
                    )
                
                .padding(.horizontal)
            Button {
                crossAction()
            } label: {
                Image(systemName: "multiply")
                    .foregroundStyle(Color.grayImages)
            }
        }.onAppear(){
            self.ingredient.scale = MeasurementUnit.grams.rawValue // Default Scale
        }.onChange(of: ingredient.quantity) {
            if let slashIndex = ingredient.quantity.firstIndex(of: "/") {
                if let indexAfterTwo = ingredient.quantity.index(slashIndex, offsetBy: 2, limitedBy: ingredient.quantity.endIndex) {
                    ingredient.quantity = String(ingredient.quantity.prefix(upTo: indexAfterTwo))
                }
            }

        }
    }
}
extension IngredientRowView{
    func scaleMenu() -> some View{
        Menu {
            Button{
                self.ingredient.scale = MeasurementUnit.grams.rawValue
            }label:{
                Text("grams")
            }
            Button{
                self.ingredient.scale = MeasurementUnit.teaspoon.rawValue
            }label: {
                Text("tsp")
            }
            Button{
                self.ingredient.scale = MeasurementUnit.tablespoon.rawValue
            }label:{
                Text("tbsp")
            }
            Button{
                self.ingredient.scale = MeasurementUnit.cups.rawValue
            }label: {
                Text("cups")
                    
            }
            Button{
                self.ingredient.scale = MeasurementUnit.mls.rawValue
            }label:{
                Text("mls")
            }
            Button {
                scale = MeasurementUnit.quantity.rawValue
            } label: {
                Text("quantity")
            }
        } label: {
            HStack {
                Text(ingredient.scale )
                    .foregroundStyle(Color.grayImages)
                    .font(.sansRegular(size: 10.38))
                Image(systemName: "chevron.down")
                    .foregroundColor(.grayImages)
            }
            .frame(width:65)
            .padding(.trailing,10)
        }
    }
    
    func portionMenu() -> some View{
            Menu {
                Button {
                    updateQuantityWithPortion(Portion.none.rawValue)
                    ingredient.quantity =   ingredient.quantity.replacingOccurrences(of: " ", with: "")
                } label: {
                    Text("...")
                }
                
                Button {
                    updateQuantityWithPortion(Portion.oneHalf.rawValue)
                } label: {
                    Text("1/2")
                }
                
                Button {
                    updateQuantityWithPortion(Portion.oneThird.rawValue)
                } label: {
                    Text("1/3")
                }
                
                Button {
                    updateQuantityWithPortion(Portion.oneFourth.rawValue)
                } label: {
                    Text("1/4")
                }
                Button {
                    updateQuantityWithPortion(Portion.twoThird.rawValue)
                } label: {
                    Text("2/3")
                }
                
                Button {
                    updateQuantityWithPortion(Portion.threeFourth.rawValue)
                } label: {
                    Text("3/4")
                }

                
            } label: {
                HStack {
                    Text(portion == Portion.none.rawValue ? "Select" : portion)
                        .foregroundStyle(Color.grayImages)
                        .font(.sansRegular(size: 10.38))
                    Image(systemName: "chevron.down")
                        .foregroundColor(.grayImages)
                }
                .frame(width:60)
                .padding(.trailing,10)
            }
        
    }
}

extension IngredientRowView{
     func updateQuantityWithPortion(_ selectedPortion: String) {
        let components = ingredient.quantity.components(separatedBy: " ")
        if components.count > 1 {
            if components[1].contains(portion) {
                ingredient.quantity = ingredient.quantity.replacingOccurrences(of: self.portion, with: selectedPortion)
            } else {
                ingredient.quantity = "\(components[0]) \(selectedPortion)"
            }
        } else {
            ingredient.quantity = "\(ingredient.quantity) \(selectedPortion)"
        }
         self.portion = selectedPortion
    }
}

#Preview{
    IngredientRowView(ingredient: .constant(Ingredient(id: 0, name: "", quantity: "2", scale: MeasurementUnit.cups.rawValue)), scale: MeasurementUnit.cups.rawValue, portion: Portion.none.rawValue) {
        
    }
}
