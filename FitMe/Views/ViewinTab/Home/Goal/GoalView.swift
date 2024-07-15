//
//  SetGoalView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 27/12/2023.
//

import SwiftUI
import Charts

struct GoalView: FitMeBaseView {

    @StateObject var viewModel = GoalViewModel()
    
//    this value is commted to avoid preview crash
    
    
    var body: some View {
        ZStack {
            loadView
            LoaderView(isLoading: $viewModel.showLoader)
            
        }.onAppear {
            viewModel.calculateGoalPercentages()
        }.onReceive(viewModel.$startDate, perform: { _ in
            Task {
                    await viewModel.requestGoalHistory()
            }
            
        })
        .navigationTitle("Daily Calories")
        .toolbarTitleDisplayMode(.inline)
        .navigationBarTitle("")
        .toolbarRole(.editor)
     
    }
}

// MARK: View Extension
extension GoalView  {
    var loadView: some View {
        VStack {
            
            caloriesBanner
            nutrientsList
            WeekDateRangeView(startDate: $viewModel.startDate, endDate: $viewModel.endDate)
            weeklyChart
            updateGoalButton
            
        }.padding()
    }
    
    var caloriesBanner: some View {
        ZStack {
            
            BlurRectangle(opcity: 0.2, color: .black)
                .frame(height: 70)
                .padding()
                .background(
                    Image("caloriesBg")
                        .scaledToFit()
                        .cornerRadius(10)
                ).clipped()
                .cornerRadius(10)

            HStack {
                Text("Total Calories")
                Spacer()
                Text(viewModel.calories)
            }
            .padding(.horizontal, 30)
            .foregroundStyle(.white)
                .font(.sansRegular(size: 24))
            
                
        }
    }
    
    func nutrient(name: String, grams: String, percentage: String) -> some View {
        HStack {
            Text(name)
                .font(.sansMedium(size: 16))
            
            Text("\(grams)g")
                .font(.sansRegular(size: 10))
                .foregroundStyle(.gray)
            Spacer()
            Text("\(percentage)%")
                .font(.sansMedium(size: 16))
            
        }
    }
    
    var updateGoalButton: some View {
        NavigationLink {
            UpdateGoalView()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 50)
                    .foregroundStyle(primaryColor)
                Text("Update Goals")
                    .foregroundStyle(.white)
                    .font(.sansMedium(size: 18))
            }
        }
    }
    
    var nutrientsList: some View {
        VStack(spacing: 10) {

            nutrient(name: "Carbohydrates",
                     grams: "\(viewModel.carbohydratesInGrams)",
                     percentage: "\(viewModel.carbohydratesPercentage)")
                       
           nutrient(name: "Protein",
                    grams: "\(viewModel.proteinInGrams)",
                    percentage: "\(viewModel.proteinPercentage)")
            
            nutrient(name: "Fats",
                     grams: "\(viewModel.fatsInGrams)",
                     percentage: "\(viewModel.fatsPercentage)")
            
        }.padding(.top, 10)
    }
    
    
    var weeklyChart: some View {
        Chart {
            BarMark(
                x: .value("Shape Type", "Mon"),
                y: .value("Total Count", viewModel.goalHistory?.monday ?? 0)
            )
            BarMark(
                x: .value("Shape Type", "Tue"),
                y: .value("Total Count", viewModel.goalHistory?.tuesday ?? 0)
            )
            BarMark(
                x: .value("Shape Type", "Wed"),
                y: .value("Total Count", viewModel.goalHistory?.wednesday ?? 0)
            )
            BarMark(
                x: .value("Shape Type", "Thu"),
                y: .value("Total Count", viewModel.goalHistory?.thursday ?? 0)
            )
            BarMark(
                x: .value("Shape Type", "Fri"),
                y: .value("Total Count", viewModel.goalHistory?.friday ?? 0)
            )
            BarMark(
                x: .value("Shape Type", "Sat"),
                y: .value("Total Count", viewModel.goalHistory?.saturday ?? 0)
            )
            BarMark(
                x: .value("Shape Type", "Sun"),
                y: .value("Total Count", viewModel.goalHistory?.sunday ?? 0)
            )
        }
        .chartYAxis(.hidden)
        .animation(.easeIn, value: viewModel.goalHistory)
        .padding(.vertical)
    }
}

#Preview {
    GoalView()
}
