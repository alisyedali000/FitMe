//
//  SelectionButton.swift
//  FitMe
//
//  Created by Ali Syed on 18/12/2023.
//
import SwiftUI
struct SelectionButton: View {
    let title: String
    let image: Image
    let isSelected: Bool
    let isSmall : Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: isSmall == true ? 6 : 12)
                .foregroundColor(isSelected ? .redColor : .textfieldBackground)

                .frame(width: isSmall == false ? 104.81 : 53)
                .frame(height: isSmall == false ? 56 : 25)
                .overlay(
                    HStack {
                        image
                            .renderingMode(.template)
                            .tint(isSelected ? Color(.white) : .grayImages)
                            .foregroundStyle(isSelected ? Color(.white) : .grayImages)
                        Text(title)
                            .foregroundStyle(isSelected ? Color(.white) : .grayImages)
                            .font(.sansRegular(size: isSmall == true ? 10 : 16))
                    }
                )
        }
    }
}

#Preview{
    SelectionButton(title: "CM's", image: Image(uiImage: UIImage()), isSelected: false, isSmall: true) {

    }
}
