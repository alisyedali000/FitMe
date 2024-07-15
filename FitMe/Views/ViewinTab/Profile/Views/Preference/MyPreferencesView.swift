//
//  MyPreferencesView.swift
//  FitMe
//
//  Created by Ali Syed on 06/12/2023.
//

import SwiftUI

struct MyPreferencesView: View {
    
    
    @Environment (\.presentationMode) var presentaionMode
    @State private var screenSelection = "Diet Preferences"
    @State var isLoading = false
    
    let mealTime = ["Diet Preferences", "Food Dislikes"]
    
    var body: some View {
        ZStack{

            loadView
            LoaderView(isLoading: $isLoading)
        } .navigationTitle("Preferences").toolbarRole(.editor)
        
    }
}

// MARK: View View extension
extension MyPreferencesView {
    
    var loadView: some View {
        ZStack{
            VStack{
                SingleButtonSelection(categories: mealTime, isUnderLineSelection: true, selection: $screenSelection)
                
                ScrollView(showsIndicators: false){
                    
                    screenSelection == "Diet Preferences" ? AnyView(DietPreferenceSelectionView(isLoading: $isLoading)) :
                    AnyView(DislikeSelectionView(isLoading: $isLoading))
                    
                }
                
            }.padding(.horizontal)
        }
    }
}


#Preview {
    MyPreferencesView()
}
