//
//  SearchDislikeView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 09/01/2024.
//

import SwiftUI

struct SearchDislikeView: FitMeBaseView {
    
    @ObservedObject var viewModel: DislikeSelectionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{

            loadView
            LoaderView(isLoading: $viewModel.showLoader)
        }
            .onReceive(viewModel.$ingridentSearchText, perform: { _ in
                Task {
                    await viewModel.searchFoodDislikes()
                }
            })
            .navigationTitle("")
            .toolbarRole(.editor)
    }
}


extension SearchDislikeView {

    var loadView: some View {
        ScrollView {
            VStack {
                SearchBar(text: $viewModel.ingridentSearchText) {
                    viewModel.ingridentSearchText = ""
                }
                
                if viewModel.ingridentSearchText.isEmpty {
                    emptyView
                } else {
                    listView
                }
            }
        }.padding()
        
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
    
    var emptyView: some View {
        Text("Please type to search ingredients")
            .font(.sansMedium(size: 16))
    }
}


#Preview {
    SearchDislikeView(viewModel: DislikeSelectionViewModel())
}
