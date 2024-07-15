//
//  ShoppingListSubView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 26/12/2023.
//

import SwiftUI
import SwiftData

// Actually in swiftUI there is not support for Runtime query descriptor.
struct ShoppingListSubView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var shoppingItems: [ShoppingItem]
    
    
    init(sort: SortDescriptor<ShoppingItem>) {
        _shoppingItems = Query(sort: [sort])
    }
    
    var body: some View {
        if shoppingItems.isEmpty {
            noShoppingItem
        } else {
            shoppingListView
        }
    }
}
extension ShoppingListSubView {
    
    var shoppingListView: some View {
        ScrollView {
            ForEach(shoppingItems, id: \.self) { shoppingItem in
                ShoppingItemCard(shoppingListItem: shoppingItem)
            }.onDelete(perform: deleteShoppingItem)
        }
    }
    
    var noShoppingItem: some View {
        VStack {
            Spacer()
            Image(ImageName.ShoppingList.shoppingBag.rawValue)
                .shadow(radius: 5)
                Text("No Shopping list added yet!")
                .font(.sansMedium(size: 16))
            Spacer()
        }
    }
}

// MARK: custom function extension
extension ShoppingListSubView {
    func deleteShoppingItem(at offsets: IndexSet) {
        for offset in offsets {
            let shoppingItem = shoppingItems[offset]
            modelContext.delete(shoppingItem)
        }
    }
}


#Preview {
    var sortOrder = SortDescriptor(\ShoppingItem.name)
    return ShoppingListSubView(sort: sortOrder)
}
