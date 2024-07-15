//
//  DiscoverView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 20/12/2023.
//

import SwiftUI

struct DiscoverView: FitMeBaseView {
    
    
    @StateObject var viewModel = DiscoverViewModel()
    
    @State private var isSearchEnable = false
    @State private var isOpeingPageFirstTime = true
    @State private var isCallinAPIFirstTime = true
    
    @State private var isFilterSheetPresented = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack {
            loadView
            LoaderView(isLoading: $viewModel.showLoader)
        }
        .navigationTitle("Discover Recipes")
        .toolbarRole(.editor)
        .toolbar(content: {
            Button {
                isFilterSheetPresented.toggle()
            } label: {
                Image("filter")
                    .foregroundStyle(primaryColor)
            }
            
        })
        .sheet(isPresented: $isFilterSheetPresented, content: {
            DiscoverFilterSheet(dislikeStatus: $viewModel.disklikeSelection, sortBy: $viewModel.sortBy, orderedBy: $viewModel.orderedBy, onApplyAction: {
                Task {
                    await viewModel.updateSort()
                }
            })
                .presentationDetents([.medium])
        })
        
        .task {
            if isCallinAPIFirstTime {
                await viewModel.requestInitialAppointmentHistory()
                isCallinAPIFirstTime.toggle()
            }
        }
        .onReceive(viewModel.$searchText, perform: { newValue in
            if newValue.isEmpty {
                viewModel.searchCancelCalled()
            } else {
                Task {
                    await viewModel.requestSearchRecipes()
                }
            }
        })
    }
}

// MAKR: View extension
extension DiscoverView {
    
    var loadView: some View {
        VStack {
            SearchBar(text: $viewModel.searchText) {
                viewModel.searchCancelCalled()
            }
            
            if viewModel.recipes.isEmpty {
                if !isOpeingPageFirstTime {
                    emptyListView
                        .onAppear {
                            isOpeingPageFirstTime = false
                        }
                }
                
            } else {
                recipesList
            }
            
            Spacer()
            
        }.padding()
    }
    
    var recipesList: some View {
        
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 20,  content: {
                
                ForEach(Array(viewModel.recipes.enumerated()), id: \.element.id) { index, element in
                    LazyVStack {
                        
                        NavigationLink {
                            RecipeDetailView(recipe: $viewModel.recipes[index])
                        } label: {
                            recipeCellContainer(index: index)
                        }
                    }
                }
            })
            
        }.padding(.top)
    }
    
    var emptyListView: some View {
        
        VStack {
            Text("No Recipes found")
        }
    }
    
    func recipeCellContainer(index: Int) -> some View {
        
        RecipeCardView(recipe: $viewModel.recipes[index], saveAction: { isSaved in
            Task {
                if (await viewModel.saveRecipe(index: index , isSaved: isSaved)) {
                    viewModel.recipes[index].saved.toggle()
                }
            }
        })
        .onAppear() {
            Task {
                await viewModel.requestMoreItemsIfNeeded(index: index)
            }
        }
    }
    
}


#Preview {
    DiscoverView()
}
