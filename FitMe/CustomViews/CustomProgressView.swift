//
//  CustomProgressView.swift
//  FitMe
//
//  Created by Ali Syed on 15/12/2023.
//

import SwiftUI

struct CustomProgressView: ProgressViewStyle {
    var color: Color
    var height: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(color.opacity(0.3))
                    .frame(width: geometry.size.width)

                RoundedRectangle(cornerRadius: 5)
                    .fill(color)
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0))
            }
        }
        .frame(height: height)
    }
}

#Preview{
    ProgressView(value: 5, total: 10)
        .progressViewStyle(CustomProgressView(color: .carbsColor, height: 13))
}

