//
//  DislikeSelectionView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 09/01/2024.
//

import SwiftUI

struct DislikeSelectionView: View {
    
    @StateObject var viewModel = DislikeSelectionViewModel()
    @Binding var isLoading : Bool
    @State var isFirstTime = true
//    @State var showUserDislikedFood = true // Showing the user collection of dislikedFood
    var body: some View {
        ZStack {
            loadView
//            LoaderView(isLoading: $viewModel.showLoader)
        }
        .onChange(of: viewModel.showLoader, {
            self.isLoading = viewModel.showLoader
        })
        
        .alert("Fit me", isPresented: $viewModel.showError, actions: {
            Button {
                
            } label: {
                Text("Ok")
            }
            
        }, message: {
            Text(viewModel.errorMessage)
        })
        
        .onAppear {
            if isFirstTime{ // prevention for reset
                viewModel.selectedDislikedFoods = UserDefaultManager.shared.get()?.foodDislikes ?? [FoodDislikes]()
                isFirstTime = false
            }
            Task{
                if viewModel.selectedCategory.id == 0{
                    await viewModel.getFoodCategories()
//                    showUserDislikedFood = true
                }else{
                    await viewModel.getFoodDislikes()
//                    showUserDislikedFood = false
                }
            }
        }.onChange(of: viewModel.selectedCategory, {
            Task {
                await viewModel.getFoodDislikes()
//                self.showUserDislikedFood = false
//                viewModel.selectedDislikedFoods = viewModel.
            }
        })
    }
}

extension DislikeSelectionView {
    
    var loadView: some View {
        
        VStack {
            
            searchNavigationLink
            VStack(alignment: .leading){
                Text("Disliked Foods")
                listViewOfSelectedDislikedFood
            }
            menuSelectionView
            Spacer()
                listView
            Spacer()
            CustomButton(title: "Update") {
                Task {
                    await viewModel.setFoodDislikes()
//                    showUserDislikedFood = true
                }
            }
        }
        
    }
    
    var searchNavigationLink: some View {
        NavigationLink {
            SearchDislikeView(viewModel: viewModel)
        } label: {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.black.opacity(0.30))
                    .opacity(0.20)
                    .frame(height: 50)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding([.leading])
                    Text("Search")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
    
    var menuSelectionView: some View {
        HStack{
            Text("Select Food Category")
            Spacer()
            Menu {
                ForEach(viewModel.foodCategories, id: \.self) { category in
                    Button {
                        viewModel.selectedCategory = category
                        Task {
                            await viewModel.getFoodDislikes()
                        }
                    } label: {
                        Text(category.name)
                    }
                }
            } label: {
                Label {
                    Text(viewModel.selectedCategory.name )
                } icon: {
                    Image(systemName: "chevron.down")
                }
            }
            
        }
    }
    
    var listView: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            ForEach(viewModel.foodDislikes , id: \.self) { food in
                
                TagSelection(title: food.name , isSelected: viewModel.selectedDislikedFoods.contains(where: {$0.id == food.id}))
                    .onTapGesture {
                        let selected  = viewModel.selectedDislikedFoods.contains(where: {$0.id == food.id})
                        if selected {
                            viewModel.selectedDislikedFoods.removeAll(where: {$0.id == food.id}) // Deselect if already selected
                        } else {
                            viewModel.selectedDislikedFoods.append(food) // Select if not selected
                        }
                        print(viewModel.selectedDislikedFoods)
                    }
            }
        }
    }
    var listViewOfSelectedDislikedFood: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            ForEach(viewModel.selectedDislikedFoods , id: \.self) { food in
                
                TagSelection(title: food.name , isSelected: true)
                    .onTapGesture {
                        viewModel.selectedDislikedFoods.removeAll(where: {$0.id == food.id})
                        print(viewModel.selectedDislikedFoods)
                    }
            }
        }
    }
    
    
    
}

#Preview {
    DislikeSelectionView(viewModel: DislikeSelectionViewModel(), isLoading: .constant(false))
}
