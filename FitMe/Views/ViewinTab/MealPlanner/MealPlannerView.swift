//
//  MealPlannerView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 22/12/2023.
//

import SwiftUI

struct MealPlannerView: FitMeBaseView {

    let mealTime = ["Today", "Weekly"]
    @StateObject var viewModel = MealPlannerViewModel()
    
    
    var body: some View {
        ZStack {
            ZStack(alignment: .bottomTrailing) {
                loadView
                floatingButton
            }

            LoaderView(isLoading: $viewModel.showLoader)
        }
    }
}

// MARK: View extension

extension MealPlannerView {
    
    var loadView: some View {
        VStack {
            navBarView
            SingleButtonSelection(categories: mealTime, isUnderLineSelection: true, selection: $viewModel.selectedMealTime)
            weekdays
            mealList
                .padding(.top)
            
        }.padding()
            .onAppear {
                
                Task {
                    if viewModel.selectedMealTime == TODAY {
                        await viewModel.requestDailyMeelPlan()
                    }
                    if viewModel.selectedMealTime == WEEKLY {
                        await viewModel.requestWeeklyMeelPlan()
                    }
                }
            }
//        these might be an issue if we select the weekly and It might supceted that code does't call the weekly meel plane
            .onReceive(viewModel.$selectedMealTime, perform: { _ in
                Task {
                    if viewModel.selectedMealTime == TODAY {
                        await viewModel.requestDailyMeelPlan()
                    }
                    if viewModel.selectedMealTime == WEEKLY {
                        await viewModel.requestWeeklyMeelPlan()
                    }
                }
            })
            .onReceive(viewModel.$selectedWeekDay, perform: { _ in
                viewModel.updateUserGoal()
                Task {
                    if viewModel.selectedMealTime == WEEKLY {
                        await viewModel.requestWeeklyMeelPlan()
                    }
                }
            })
    }
    
    var navBarView: some View {
        HStack {
            Spacer()
            Text("Meal planner")
                .font(.sansMedium(size: 20))
                .offset(x: 40)
            Spacer()
            
            NavigationLink {
                MealHistoryView()
            } label: {
                HStack {
                    Image(systemName: "hourglass.bottomhalf.filled")
                    Text("History")
                        .font(.sansRegular(size: 13))
                }
            }.foregroundStyle(primaryColor)
            
        }
    }
    
    var weekdays: some View {
        viewModel.selectedMealTime == WEEKLY ?
            AnyView(
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        SingleButtonSelection(categories: WEEKDAYS, selection: $viewModel.selectedWeekDay)
                    }.padding(.vertical, 10)
                    if let _ = viewModel.todayIntake {
                        goalCard()
                    }
                    
                }
                
            )
        :
            AnyView(EmptyView())
        
    }
    
    func goalCard() -> some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 177)
                .cornerRadius(15)
                .shadow(color: .textfieldBackground, radius: 15)
            
            
            VStack(alignment: .leading){
                HStack{
                    Text("\(viewModel.selectedWeekDay) Calories Intake")
                        .font(.sansMedium(size: 14.35))
                    Spacer()
//                    Text("Set Goal")
//                        .font(.sansMedium(size: 8.97))
//                        .foregroundStyle(Color.redColor)
                }
                HStack{
                    Text("Today's Calories Goal")
                        .font(.sansRegular(size: 14))
                        .foregroundStyle(Color.redColor)
                    
                    Spacer()
                    Text("\(viewModel.userGoal.caloriesInt ) KCAL")
                        .font(.sansRegular(size: 10))
                    
                    
                }
                ProgressView(value: Double(viewModel.todayIntake?.caloriesInt ?? 0), total: Double(viewModel.userGoal.caloriesInt ))
                    .progressViewStyle(CustomProgressView(color: .red, height: 13))
                
                HStack (spacing: 14){
                    
                    NutrientBarView(title: "Carbs Intake", filledValue: viewModel.todayIntake?.carbohydratesInt ?? 0, totalValue: viewModel.userGoal.carbohydratesInt , color: .carbsColor)
                    
                    
                    NutrientBarView(title: "Fats Intake", filledValue: viewModel.todayIntake?.fatsInt ?? 0, totalValue: viewModel.userGoal.fatsInt , color: .fatsColor)
                    
                    NutrientBarView(title: "Protein Intake", filledValue: viewModel.todayIntake?.proteinInt ?? 0, totalValue: viewModel.userGoal.proteinInt , color: .proteinColor)
                    
                }
                
            }.padding(.horizontal)
        }
    }
    
    var mealList: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
                MealTypeWithRecipesList(title: BREAKFAST, mealDay: viewModel.getMealDay(), recipes: $viewModel.breakfast) { selectedMealType in
                    debugPrint(selectedMealType)
                }
                MealTypeWithRecipesList(title: LUNCH, mealDay: viewModel.getMealDay(), recipes: $viewModel.lunch) { selectedMealType in
                    debugPrint(selectedMealType)
                }
                
                MealTypeWithRecipesList(title: SNACKS, mealDay: viewModel.getMealDay(), recipes: $viewModel.snacks) { selectedMealType in
                    debugPrint(selectedMealType)
                }
                
                MealTypeWithRecipesList(title: DINNER, mealDay: viewModel.getMealDay(), recipes: $viewModel.dinner) { selectedMealType in
                    debugPrint(selectedMealType)
                }
                
            }
            
        }
    }
    
    var floatingButton: some View {
        NavigationLink{
            DiscoverView()
        }label: {
            ImageName.addRecipeIcon
                .resizable()
                .frame(width: 56 , height: 56)
        }.padding()
    }
    
}

#Preview {
    MealPlannerView()
}
