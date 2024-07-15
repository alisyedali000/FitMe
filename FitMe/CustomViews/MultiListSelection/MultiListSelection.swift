//
//  MultiListSelection.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 21/12/2023.
//

import SwiftUI

protocol Selectable: Identifiable {
    var name: String { get }
}

struct GenericMultiListSelection<T: Selectable>: View {
    
    var list: [T]
    @Binding var selectedItems: [String]
    
    
    var body: some View {
        loadView
    }
}


extension GenericMultiListSelection {
    
    var loadView: some View {
        VStack(spacing: 10) {
            ForEach(list, id: \.id) { item in
                MultiListSelectionButton(title: item.name, isSelected: selectedItems.contains(item.name)) { item in
                    if selectedItems.contains(item) {
                        selectedItems.remove(at: selectedItems.firstIndex(of: item) ?? 0)
                    } else {
                        selectedItems.append(item)
                    }
                }
            }
        }
    }
}


struct MultiListSelection: View {
    
    var list: [String]
    @Binding var selectedItems: [String]
    
    
    var body: some View {
        loadView
    }
}

// MAKR: View extension
extension MultiListSelection {
    
    var loadView: some View {
        VStack(spacing: 10) {
            ForEach(list, id: \.self) { item in
                MultiListSelectionButton(title: item, isSelected: selectedItems.contains(item)) { item in
                    if selectedItems.contains(item) {
                        selectedItems.remove(at: selectedItems.firstIndex(of: item) ?? 0)
                    } else {
                        selectedItems.append(item)
                    }
                    
                }
            }
        }
    }
}


#Preview {
    MultiListSelection(list: WEEKDAYS, selectedItems: .constant(["Friday"]))
}

