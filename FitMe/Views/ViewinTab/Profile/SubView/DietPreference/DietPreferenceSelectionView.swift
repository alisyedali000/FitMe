//
//  DietPreferenceView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 08/01/2024.
//

import SwiftUI

struct DietPreferenceSelectionView: View {
    
    
    @StateObject var viewModel = DietPreferenceSelectionViewModel()
    @Binding var isLoading : Bool
    
    var body: some View {
        ZStack {
            loadView
//            LoaderView(isLoading: $viewModel.showLoader)
        }
        
        .onAppear(perform: {
            Task {
                await viewModel.getDietPreferences()
            }
        })
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
    }
}

// MARK: UIView Extension

extension DietPreferenceSelectionView {
    var loadView: some View {
        
        VStack {
            Spacer()
            GenericMultiListSelection(list: viewModel.dietPreferences, selectedItems: $viewModel.selectedPreferencesName)

            Spacer()
            
            CustomButton(title: "Update") {
                Task {
                    await viewModel.updateDitePreferences()
                }
                
            }
        }
        
    }
    
    
    var preferencesTagSelection: some View {
        
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            
            ForEach(viewModel.dietPreferences.indices, id: \.self) { index in
                
                TagSelection(title: viewModel.dietPreferences[index].displayName, isSelected: viewModel.dietPreferences[index].isSelected)
                    .onTapGesture {
                        withAnimation {
                            //                                make all other as false for single selection and in future use the same for multi selecction
                            for index in viewModel.dietPreferences.indices {
                                viewModel.dietPreferences[index].select = false
                            }
                            
                            viewModel.dietPreferences[index].select = !(viewModel.dietPreferences[index].select ?? false)
                            
                        }
                    }
            }
            
        }
        
    }
}

#Preview {
    DietPreferenceSelectionView(isLoading: .constant(false))
}
