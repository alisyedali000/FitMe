//
//  DonutChart.swift
//  FitMe
//
//  Created by Ali Syed on 13/12/2023.
//

import SwiftUI
import Charts

struct DonutChart: View {
    @Binding var details : RecipeModel
    @State var carbsPercent = 0
    @State var proteinPercent = 0
    @State var fatsPercent = 0
    @State var data = [
        (name: "Carbohydrates", sales: 100, color: Color.carbsColor),
        (name: "Protein", sales: 100, color: Color.proteinColor),
        (name: "Fats", sales: 100, color: Color.fatsColor)
    ]
    
    var body: some View {
        VStack(alignment : .leading){
            Text("Nutrition Per Serving")
                .font(.sansMedium(size: 14))
            HStack {
                
                ZStack{
                    Chart(data, id: \.name) { name, sales, color in
                        SectorMark(
                            angle: .value("Value", sales),
                            innerRadius: .ratio(0.750),
                            outerRadius: .inset(8)
                        )
                        .foregroundStyle(color)
                    }.frame(width: 92, height: 92)
                    
                    VStack{
                        Text("\(details.calories ?? "")")
                            .font(.sansRegular(size: 15))
                        Text("Cal")
                            .font(.sansRegular(size: 11))
                            .foregroundStyle(Color.grayImages)
                    }
                    
                }
                Spacer()
                nutrientsDetails(percent: carbsPercent, quantity: data[0].sales, name: "Carbs", color: .carbsColor)
                Spacer()
                nutrientsDetails(percent: proteinPercent, quantity: data[1].sales, name: "Proteins", color: .proteinColor)
                Spacer()
                nutrientsDetails(percent: fatsPercent, quantity: data[2].sales, name: "Fats", color: .fatsColor)
                
                
            }
        }
        .onChange(of: details) {
            withAnimation(.linear(duration: 1)) {
                self.updateChartData()
            }
            
        }.onAppear(){
            withAnimation(.linear(duration: 1)) {
                self.updateChartData()
            }
        }
    }
}
extension DonutChart{
    func nutrientsDetails(percent : Int, quantity: Int, name : String, color : Color) -> some View{
        VStack{
            Text("\(percent)%")
                .foregroundStyle(color)
                .font(.sansMedium(size: 14))
            Text("\(quantity)g")
                .font(.sansRegular(size: 16))
            Text(name)
                .font(.sansRegular(size: 12))
                .foregroundStyle(Color.grayImages)
         
        }
    }
    func updateChartData() {
        let carbs = Double(details.carbohydrates ) ?? 0.0
        let fats = Double(details.fats ) ?? 0.0
        let protein = Double(details.protein ) ?? 0.0
        
        let total = carbs + fats + protein // Calculate total sum
        
        data[0].sales = Int(carbs)
        data[1].sales = Int(protein)
        data[2].sales = Int(fats)
        
        if total != 0 {
            carbsPercent = Int((carbs / total) * 100.0)
            proteinPercent = Int((protein / total) * 100.0)
            fatsPercent  = Int((fats / total) * 100.0)
        } else {
            // Handle the case where total is zero to avoid division by zero
            // For example, set all percentages to 0 or handle it based on your requirements
            carbsPercent = 0
            proteinPercent = 0
            fatsPercent = 0
        }
    }
}

// Preview
struct DonutChart_Previews: PreviewProvider {
    static var previews: some View {
        DonutChart(details: .constant(mockRecipes.first!))
    }
}
