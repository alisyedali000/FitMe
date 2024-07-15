//
//  TestView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 28/12/2023.
//

// MARK: This is a testing view for just test purpose.

import SwiftUI
import Charts

struct ToyShape: Identifiable {
    var type: String
    var count: Double
    var id = UUID()
}

struct WeeklyCaloriesChartView: View {
    let weeklyData: [String: Double]

    var body: some View {
        VStack {
           
                Chart {
                    ForEach(weeklyData.sorted(by: { $0.key < $1.key }), id: \.key) { day, calories in
                        BarMark(
                            x: .value("Day", day),
                            y: .value("Calories", calories)
                        )
                    }
                }
        }
        .navigationBarTitle("Weekly Calories Chart", displayMode: .inline)
    }
}

struct WeeklyCaloriesChartView_Previews: PreviewProvider {
    static var previews: some View {
        let weeklyData: [String: Double] = ["Monday": 1000, "Tuesday": 1200, "Wednesday": 800, "Thursday": 1500, "Friday": 1300, "Saturday": 1100, "Sunday": 900]

        return NavigationView {
            WeeklyCaloriesChartView(weeklyData: weeklyData)
        }
    }
}
