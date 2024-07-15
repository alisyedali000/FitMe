//
//  ShoppingListViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 26/12/2023.
//

import Foundation
import SwiftData
import Darwin


extension ShoppingListView {
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var shoppingItems = [ShoppingItem]()
//        Error variable for showing error message
        var showError = false
        var errorMessage = ""

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }
        
        func showError(message: String) {
            errorMessage = message
            showError = true
        }
        
        func fetchData() {
            shoppingItems = []
            do {
                let descriptor = FetchDescriptor<ShoppingItem>(sortBy: [SortDescriptor(\.name)])
                shoppingItems = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
        }
        
        func isItemSelected() -> Bool {
            fetchData()
            return !shoppingItems.filter { $0.isChecked }.isEmpty
        }
        
        func isListEmpty() -> Bool {
            fetchData()
            return shoppingItems.isEmpty
        }

        func deleteShoppingItem() {
//            to get the updated data
            fetchData()
            
            guard isItemSelected() else {
                // No item selected, do nothing
                return
            }

            // Filter out the selected items
            let selectedItems = shoppingItems.filter { $0.isChecked }

            
                // Delete the selected items from the modelContext
                for selectedItem in selectedItems {
                        modelContext.delete(selectedItem)
                }

            // Optional: Clear the selection status after deletion
            shoppingItems.forEach { $0.isChecked = false }
        }    
       
        func getAllShoppingItemNames() -> [String] {
            var nameList = [String]()
            
            for (index, shoppingItem) in shoppingItems.enumerated() {
                let itemName = shoppingItem.name
                let quantity = shoppingItem.quantity
                let measuringUnit = shoppingItem.measuringUnit
                
                let itemInfo = "\(index + 1). \(itemName)\n   Quantity: \(quantity)\n   Unit: \(measuringUnit)"
                nameList.append(itemInfo)
            }
            
            return nameList
        }
        
        // MARK: - Merge Function
        func hasMatchingItems() -> Bool {
            fetchData()

            let uniqueKeys = Set(shoppingItems.map { "\($0.name.lowercased())_\($0.measuringUnit.lowercased())" })

            return shoppingItems.count > uniqueKeys.count
        }
        

        
//        func mergeMatchingItems() {
//
//            var mergedItems = [String: [ShoppingItem]]()
//
//            for item in shoppingItems {
//                let key = "\(item.name.lowercased())_\(item.measuringUnit.lowercased())"
//
//                if var existingItems = mergedItems[key] {
//                    existingItems.append(item)
//                    mergedItems[key] = existingItems
//                } else {
//                    mergedItems[key] = [item]
//                }
//            }
//
//            for (_, items) in mergedItems where items.count > 1 {
//                let totalQuantity = items.compactMap { Int($0.quantity) }.reduce(0, +)
//
//                if let lastItem = items.last {
//                    lastItem.quantity = "\(totalQuantity)"
//
//                    for item in items.dropLast() {
//                        debugPrint(item.id)
//                        modelContext.delete(item)
//                    }
//                    /**
//                     Deleting a SwiftData object takes two steps: calling delete() on your model context, passing in the object you want to delete, then saving the changes, either with an explicit call to save() or waiting for the autosave to trigger if you have it enabled.
//                     */
//                    do {
//                      try  modelContext.save()
//                    } catch {
//                        debugPrint(error.localizedDescription)
//                    }
//                    
//                }
//                
//            }
//        }
        
        func mergeMatchingItems() {
            var mergedItems = [String: [ShoppingItem]]()

            for item in shoppingItems {
                let key = "\(item.name.lowercased())_\(item.measuringUnit.lowercased())"

                if var existingItems = mergedItems[key] {
                    existingItems.append(item)
                    mergedItems[key] = existingItems
                } else {
                    mergedItems[key] = [item]
                }
            }

            for (_, items) in mergedItems where items.count > 1 {
                var totalQuantity = 0.0  // Use Double to handle fractional quantities

                for item in items {
                    let quantityComponents = item.quantity.components(separatedBy: " ")

                    // Check if the quantity has both whole and fraction parts
                    if quantityComponents.count == 2, let wholePart = Int(quantityComponents[0] == "" ? "0" : quantityComponents[0]) , let fractionPart = parseFraction(quantityComponents[1]) { // checking if the whole part is empty then assigning whole part a (0) because there are always two components as ["", "1/2"] instance when there is only fraction part in item.quantity which does not satisfy the condition with an empty component.
                        if wholePart == 0{
                            totalQuantity += fractionPart  // ignoring zero
                        }else{
                            totalQuantity += Double(wholePart) + fractionPart // if there are two components with an actual value ["4", "1/3"]
                        }
                    } else if let quantityValue = Double(item.quantity) {
                        // If the quantity is a simple number without fractions
                        totalQuantity += quantityValue
                    }
                }


                if let lastItem = items.last {
                    lastItem.quantity = formatQuantity(totalQuantity)

                    for item in items.dropLast() {
                        debugPrint(item.id)
                        modelContext.delete(item)
                    }

                    do {
                        try modelContext.save()
                    } catch {
                        debugPrint(error.localizedDescription)
                    }
                }
            }
        }

        // Helper function to parse fractions and return a Double
        private func parseFraction(_ fraction: String) -> Double? {
            let components = fraction.components(separatedBy: "/")

            if components.count == 2, let numerator = Double(components[0]), let denominator = Double(components[1]), denominator != 0 {
                return numerator / denominator
            }

            return nil
        }

        // Helper function to format Double quantity as a string (with fraction if applicable)
        private func formatQuantity(_ quantity: Double) -> String {
            let wholePart = Int(quantity)
            let fractionalPart = quantity - Double(wholePart)

            if fractionalPart == 0 {
                return "\(wholePart)"
            } else {
                return "\(wholePart) \(formatFraction(fractionalPart))"
            }
        }

        // Helper function to format a fractional part as a string
        private func formatFraction(_ fraction: Double) -> String {
            let epsilon = 0.0001  // A small value to handle floating-point precision issues

            for denominator in 2...100 {
                let numerator = fraction * Double(denominator)

                if abs(numerator.rounded() - numerator) < epsilon {
                    return "\(Int(numerator.rounded()))/\(denominator)"
                }
            }

            return "\(fraction)"
        }

   
    }
    
    func deleteItem(shoppingItem: ShoppingItem) {
        modelContext.delete(shoppingItem)
        do {
            try  modelContext.save()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
