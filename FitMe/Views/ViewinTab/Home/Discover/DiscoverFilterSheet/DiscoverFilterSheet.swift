//
//  DiscoverFilterSheet.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 11/01/2024.
//

import SwiftUI

struct DiscoverFilterSheet: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var likeselection = ["On", "Off"]
    var macrosName = ["Proteins", "Calories", "Fats", "Carbs"]
    var orderBy = ["High-Low", "Low-High"]
    
    @Binding var dislikeStatus: String
    @Binding var sortBy: String
    @Binding var orderedBy: String

    
    var onApplyAction: () -> Void

    
    var body: some View {
        loadView
            .padding()
    }
}

// MARK: VIew Extesion
extension DiscoverFilterSheet {
    var loadView: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Text("Dislikes")
                    .font(.sansMedium(size: 14))
                SingleButtonSelection(categories: likeselection, selection: $dislikeStatus)
            }
            
            VStack(alignment: .leading) {
                Text("Sort by")
                    .font(.sansMedium(size: 14))
                SingleButtonSelection(categories: macrosName, selection: $sortBy)
            }
            
            VStack(alignment: .leading) {
                Text("Order by")
                    .font(.sansMedium(size: 14))
                SingleButtonSelection(categories: orderBy, selection: $orderedBy)
            }
            
            
            VStack {
                CustomButton(title: "Apply") {
                    onApplyAction()
                    presentationMode.wrappedValue.dismiss()
                }
                
                CancelButton(title: "Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }.padding(.top)
            
            
        }
    }
}

#Preview {
    DiscoverFilterSheet(dislikeStatus: .constant("On"), sortBy: .constant("Proteins"), orderedBy: .constant("High-Low")) {
        
    }
}
