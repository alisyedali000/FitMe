//
//  MealHistoryView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 29/12/2023.
//

import SwiftUI

struct MealHistoryView: View {
    
    
    @State private var isCalanderPresented = false
    @StateObject private var viewModel = MealHistoryViewModel()
    @State private var isCallingAPIFirstTime = true
    var dateBeforeToday =  Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    
    var body: some View {
        
        ZStack {
            loadView
            LoaderView(isLoading: $viewModel.showLoader)
        }
            .navigationTitle("Meal History")
            .toolbarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .task {
                if isCallingAPIFirstTime {
                    Task {
                        await viewModel.requestMealHistory()
                        isCallingAPIFirstTime.toggle()
                    }
                }
                
            }
            .onReceive(viewModel.$selecteDate, perform: { _ in
                debugPrint(viewModel.selecteDate)
                Task {
                    await viewModel.requestMealHistory()
                }
            })
    }
}


// MARK: Custom function extesnion
extension MealHistoryView {
    var loadView: some View {
        VStack {
            selecteDateView
                .padding(.vertical)
            
            ScrollView(showsIndicators: false) {
                if isCalanderPresented {
                    DatePicker("", selection: $viewModel.selecteDate, in: ...dateBeforeToday, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                    
                }
                mealList
            }
            
        }.padding()
    }
    
    
    var selecteDateView: some View {
        VStack(alignment: .leading,spacing: 10) {
            
            Button {
                withAnimation {
                    isCalanderPresented.toggle()
                }
                    
            } label: {
                HStack{
                    Text("Select Date")
                        .font(.sansMedium(size: 16))
                        .foregroundStyle(.black)
                        
                    Spacer()
                    HStack {
                        Image(systemName: "calendar")
                        Text("\(DateManager.shared.getString(from: viewModel.selecteDate))")
                        Image(systemName: isCalanderPresented ? "chevron.up" : "chevron.down")
                    }.foregroundColor(.gray)
                    
                }
                    
            }
        }
    }
    
    
    var mealList: some View {
        
        VStack(spacing: 10) {
            MealTypeWithRecipesList(title: BREAKFAST, mealDay: "", recipes: $viewModel.breakfast) { selectedMealType in
                debugPrint(selectedMealType)
            }
            MealTypeWithRecipesList(title: LUNCH, mealDay: "", recipes: $viewModel.lunch) { selectedMealType in
                debugPrint(selectedMealType)
            }
            MealTypeWithRecipesList(title: DINNER, mealDay: "", recipes: $viewModel.dinner) { selectedMealType in
                debugPrint(selectedMealType)
            }
            MealTypeWithRecipesList(title: SNACKS, mealDay: "", recipes: $viewModel.snacks) { selectedMealType in
                debugPrint(selectedMealType)
            }
        }
        
    }
}

#Preview {
    MealHistoryView()
}
