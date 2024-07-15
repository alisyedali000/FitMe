//
//  UpdateGoalView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 28/12/2023.
//

import SwiftUI

struct UpdateGoalView: FitMeBaseView {
    
    @StateObject var viewModel = UpdateGoalViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {

        
        ZStack {
            loadView
            LoaderView(isLoading: $viewModel.showLoader)
        }
        .navigationBarTitle("")
        .navigationTitle("Update Goal")
        .toolbarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
            
    }
}

// MAKR: View Extension
extension UpdateGoalView {
    var loadView: some View {
        VStack(spacing: 20) {
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Calories")
                    .font(.sansMedium(size: 16))
                FitmeTextField(placeholder: "Enter number of calories", text: $viewModel.calories)
                    
            }.padding(.top, 20)
            
            
            
            VStack {
                sliderHeading(title: "Carbohydrates", grams: viewModel.carbohydratesInGrams, value: Int(viewModel.carbohydrates))
                Slider(value:  Binding<Double>(
                    get: { Double(viewModel.carbohydrates) },
                    set: { viewModel.carbohydrates = Int($0) }
                ),
                       in: 0...100,
                       step: 5)
            }
            
            VStack {
                sliderHeading(title: "Protein", grams: viewModel.proteinInGrams, value: Int(viewModel.protein))
                Slider(value:  Binding<Double>(
                    get: { Double(viewModel.protein) },
                    set: { viewModel.protein = Int($0) }
                ),
                       in: 0...100,
                       step: 5)
            }
            
            VStack {
                sliderHeading(title: "Fats", grams: viewModel.fatsInGrams, value: Int(viewModel.fats))
                Slider(value:  Binding<Double>(
                    get: { Double(viewModel.fats) },
                    set: { viewModel.fats = Int($0) }
                ),
                       in: 0...100,
                       step: 5)
            }

            
            sumIndicator
            
            Spacer()
            
            CustomButton(title: "Update") {
                Task {
                    if await viewModel.updateGoal() {
                        SHOULD_CALL_HOME_API = true
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }.disabled(!viewModel.isSumEqualTo100)
            
            
        }.padding()
    }
    
    
    
    func sliderHeading(title : String, grams: Int, value: Int) -> some View{
        HStack{
            HStack {
                Text(title)
                    .font(.sansMedium(size: 16))
                Text("\(grams)g")
                    .font(.sansMedium(size: 12))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            Text("\(value)%")
                .font(.sansBold(size: 16))
        }
        
    }
    
    var sumIndicator: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("% Total")
                    .font(.sansMedium(size: 18))
                Spacer()
                Text("\(viewModel.totalSum) %")
                    .font(.sansMedium(size: 20))
                    .foregroundStyle(viewModel.isSumEqualTo100 ? .green.opacity(0.8) : .red)
                
            }
            Text("Macronutrients must equal 100%")
                .font(.sansRegular(size: 14))
                .foregroundStyle(.black.opacity(0.8))
        }.padding(.vertical,  10)
            .padding(.horizontal,  20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(primaryColor)
                .opacity(0.15)
        ).padding(.top)
    }
    
}

#Preview {
    UpdateGoalView()
}
