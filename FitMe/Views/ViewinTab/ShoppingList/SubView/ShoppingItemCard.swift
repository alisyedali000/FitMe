//
//  ShoppingItemCard.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 26/12/2023.
//

import SwiftUI
import SwiftData

struct ShoppingItemCard: FitMeBaseView {
    
    var shoppingListItem: ShoppingItem
    
    
    var body: some View {
        loadView
    }
}

// MARK: View Extension

extension ShoppingItemCard {
    var loadView: some View {
        Button(action: {
            shoppingListItem.isChecked.toggle()
        }, label: {
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 50)
                    .foregroundStyle(shoppingListItem.isChecked ? primaryColor : textFieldColor)
                
                HStack {
                    VStack(alignment: .trailing) {
                        Text(shoppingListItem.quantity)
                            .foregroundStyle(shoppingListItem.isChecked ? .white : .textGray)
                            .font(.sansRegular(size: 14))
                        
                        Text(shoppingListItem.measuringUnit)
                            .foregroundStyle(shoppingListItem.isChecked ? .white : .textGray)
                            .font(.sansRegular(size: 8))
                    }
                    
                    Text(" \(shoppingListItem.name)" )
                        .foregroundStyle(shoppingListItem.isChecked ? .white : .textGray)
                        .font(.sansRegular(size: 14))
                    
                    Spacer()
                    
                    Image(systemName: shoppingListItem.isChecked ? "checkmark.circle.fill" : "circle")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .scaledToFit()
                        .foregroundStyle(shoppingListItem.isChecked ?  .white : .textGray)
                        
                }.padding(.horizontal)
                
            }
        })
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ShoppingItem.self, configurations: config)
        let example = mockShoppingList.first!
        
        return  ShoppingItemCard(shoppingListItem: example)
            .modelContainer(container)
    } catch {
        return Text("Failt to load context with error \(error.localizedDescription)")
    }
    
}
