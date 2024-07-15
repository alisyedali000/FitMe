//
//  AddShoppingItemSheet.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 26/12/2023.
//

import SwiftUI
import SwiftData

struct AddShoppingItemSheet: FitMeBaseView {
    
    @State private var name = ""
    @State private var quantity = ""
    @State private var portion = Portion.none.rawValue
    @State private var measuringUnit = MeasurementUnit.grams.rawValue
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        loadView
            .padding(10)
            .alert(isPresented: $showError, content: {
                        Alert(title: Text(errorMessage))
                    })
    }
}

// MARK: view extension
extension AddShoppingItemSheet {
    
    var loadView: some View {
        
        
        VStack(spacing: 20) {
            
            Text("Add Items")
                .font(.sansMedium(size: 20))
            
            SimpleTextField(placeholder: "Item Name...", value: $name)
            HStack {
                Text("Quantity")
                    .font(.sansMedium(size: 16))
                    .padding(.horizontal)
                Spacer()
                QuantityInputView(quantity: $quantity, scale: $measuringUnit, portion: $portion)
                    
            }
            
            CustomButton(title: "Add Item") {
                addItemToList()
            }
            CancelButton(title: "Cancel") {
                self.dismiss()
            }
        }
    }
}

// custom function extension

extension AddShoppingItemSheet {
    func showErrorAlert(message: String) {
        errorMessage = message
        showError.toggle()
    }
    
    
    func isDataValidation() -> Bool {
        
        if name.isEmpty {
            showErrorAlert(message: "Name of Item cannot be empty")
            return false
        }
        
        if quantity.isEmpty {
            showErrorAlert(message: "Please enter quantity")
            return false
        }
        
        return true
    }
    
    func addItemToList() {
        
        
        
        if isDataValidation() {
            name = name.trimmingCharacters(in: .whitespaces)
            let shoppingItem = ShoppingItem(id: UUID(), quantitly: quantity, name: name, measuringUnit: measuringUnit, isChecked: false, createAt: Date())
            modelContext.insert(shoppingItem)
            self.dismiss()
            
        }
        
    }
    
 
    
}


#Preview {
    AddShoppingItemSheet()
}
