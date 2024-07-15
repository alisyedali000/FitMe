//
//  QuantityInputView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 26/12/2023.
//

import SwiftUI


struct QuantityInputView: View {
    
    
    @Binding var quantity: String
    @Binding var scale: String
    @Binding var portion : String
    var body: some View {
        loadView
            .onChange(of: quantity) {
                if let slashIndex = quantity.firstIndex(of: "/") {
                    if let indexAfterTwo = quantity.index(slashIndex, offsetBy: 2, limitedBy: quantity.endIndex) {
                        quantity = String(quantity.prefix(upTo: indexAfterTwo))
                    }
                }

            }

    }
}

// MARK: View Extension
extension QuantityInputView {
    var loadView: some View {
        
        HStack(spacing: 5) {
            TextField("Enter Quantity...", text:  $quantity)
            .font(.sansRegular(size: 12))
            .keyboardType(.numberPad)
            
            Spacer()
            HStack{
                scaleMenu
                portionMenu
            }
            
        }.lineLimit(1)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.textfieldBackground)
        )
    }
    
    var scaleMenu: some View {
        Menu {
            Button {
                scale = MeasurementUnit.grams.rawValue
            } label: {
                Text("grams")
            }
            
            Button {
                scale = MeasurementUnit.teaspoon.rawValue
            } label: {
                Text("tsp")
            }
            
            Button {
                scale = MeasurementUnit.tablespoon.rawValue
            } label: {
                Text("tbsp")
            }
            
            Button {
                scale = MeasurementUnit.cups.rawValue
            } label: {
                Text("cups")
            }
            
            Button {
                scale = MeasurementUnit.mls.rawValue
            } label: {
                Text("mls")
            }
            
            Button {
                scale = MeasurementUnit.quantity.rawValue
            } label: {
                Text("quantity")
            }
       
        } label: {
            HStack {
                Text(scale)
                    .frame(minWidth: 40)
                    .foregroundStyle(Color.grayImages)
                    .font(.sansRegular(size: 11))
                Image(systemName: "chevron.down")
                    .foregroundColor(.grayImages)
            }

        }
    }
    var portionMenu: some View {
        Menu {
            Button {
                updateQuantityWithPortion(Portion.none.rawValue)
                quantity = quantity.replacingOccurrences(of: " ", with: "")
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
                Text(portion == Portion.none.rawValue ? "Select..." : portion)
                    .frame(minWidth: 40)
                    .foregroundStyle(Color.grayImages)
                    .font(.sansRegular(size: 11))
                Image(systemName: "chevron.down")
                    .foregroundColor(.grayImages)
            }

        }
    }
    
}
extension QuantityInputView{
    private func updateQuantityWithPortion(_ selectedPortion: String) {
        let components = quantity.components(separatedBy: " ")
        if components.count > 1 {
            if components[1].contains(portion) {
                quantity = quantity.replacingOccurrences(of: portion, with: selectedPortion)
            } else {
                quantity = "\(components[0]) \(selectedPortion)"
            }
        } else {
            quantity = "\(quantity) \(selectedPortion)"
        }
        portion = selectedPortion
    }
}


#Preview {
    QuantityInputView(quantity: .constant(""), scale: .constant(MeasurementUnit.grams.rawValue), portion: .constant(""))
        .frame(width: 200)
}
