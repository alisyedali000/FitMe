//
//  SingleButtonSelection.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 21/12/2023.
//

import SwiftUI

struct SingleButtonSelection: FitMeBaseView {
    
    var categories: [String]
    var isUnderLineSelection = false
    @Binding var selection: String
    
    
    var body: some View {
        loadView()
    }
}

extension SingleButtonSelection {
    
    func loadView() -> some View {
    
        isUnderLineSelection ? AnyView(underLineHiglightedSelection) : AnyView(buttonHiglightedSelection)

    }
    
    var buttonHiglightedSelection: some View {
        HStack(spacing: 10) {
            ForEach(categories, id: \.self) { category in
                VStack(alignment: .leading, spacing: 0) {
                    Text(category)
                        .font(.sansRegular(size: 16))
                        .foregroundColor(selection == category ? .white : .textGray)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(selection == category ? primaryColor : textFieldColor)
                        )
                                            
                }.onTapGesture {
                    withAnimation{
                        selection = category
                    }
                }
                
            }
        }
    }
    
    var underLineHiglightedSelection: some View {
        HStack(spacing: 10) {
            ForEach(categories, id: \.self) { category in
                VStack(alignment: .leading, spacing: 0) {
                    VStack {
                        Text(category)
                            .font(.sansRegular(size: 16))
                            .foregroundColor(selection == category ? primaryColor : .textGray)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(selection == category ? primaryColor : .textGray)
                    }
                    
                                            
                }.onTapGesture {
                    withAnimation{
                        selection = category
                    }
                }
                
            }
        }
    }

    
}

#Preview {
    SingleButtonSelection(categories: ["Today's", "Weekly"], selection: .constant("Weekly"))
}
