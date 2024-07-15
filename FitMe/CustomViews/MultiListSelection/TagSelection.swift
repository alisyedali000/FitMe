//
//  TagSelection.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 09/01/2024.
//

import SwiftUI

struct TagSelection: View {
    
    var title: String
    var isSelected: Bool
    
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(isSelected ? .redColor : .textfieldBackground)
                .frame(minWidth:140)
                .frame(height: 40)
                .cornerRadius(6)
                .overlay(
                    HStack {
                        Text(title)
                            .font(.sansRegular(size: 15))
                            .foregroundColor(isSelected ? .white : .gray)
                        Spacer()
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circlebadge")
                            .foregroundColor(isSelected ? .white : .grayImages)
                            .frame(width: 16, height: 16)
                    }.padding(.horizontal, 10)
                )
        }
    }
}

#Preview {
    TagSelection(title: "Ammar", isSelected: true)
}
