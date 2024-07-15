//
//  NutrientBarView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 27/12/2023.
//

import SwiftUI

struct NutrientBarView: View {
    
    let title: String
    let filledValue: Int
    let totalValue: Int
    let color: Color
    
    var body: some View {
        loadView
    }
}

extension NutrientBarView {
    
    var loadView: some View {
        VStack(alignment: .leading){
            Text("\(totalValue)g")
                .font(.sansRegular(size: 10))
            Text(title)
                .font(.sansRegular(size: 8))
                .foregroundStyle(color)
            ProgressView(value: Double(filledValue), total: Double(totalValue))
                .progressViewStyle(CustomProgressView(color: color, height: 8.97))
        }
    }
    
}


#Preview {
    NutrientBarView(title: "Carb Intake", filledValue: 900, totalValue: 1000, color: .carbsColor)
}
