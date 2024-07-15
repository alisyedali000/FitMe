//
//  SavedRecipesView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 04/01/2024.
//

import SwiftUI

struct SavedRecipesView: FitMeBaseView {
    
    @StateObject var rVM = RecipeViewModel()
    @State var showSearches = false
    
    var body: some View {
        
        loadView
            .navigationTitle("")
            .toolbarRole(.editor)
            .onAppear(){
                Task{
                    async let recipes : () = rVM.getSavedRecipes()
                    _ = await[recipes]
                }
            }
    }
}

// MARK: - View Extension
extension SavedRecipesView {
    
    var loadView: some View  {
        ZStack{
            screenView()
            LoaderView(isLoading: $rVM.showLoader)
        }.onReceive(rVM.$searchText, perform: { _ in
            if rVM.searchText.isEmpty {
                rVM.updateRecipesList()
            } else {
                rVM.searchRecipe()
            }
        })
    }
    
}


extension SavedRecipesView {
    func screenView() -> some View{
        VStack{
            header()
            ZStack(alignment: .bottomTrailing){
                
                if rVM.recipesToShow.count > 0{
                    
                    myRecipesList()
                    
                }else{
                    placeHolder()
                }
            }
        }.padding(.horizontal)
    }
    
    func header() -> some View{
        VStack{
            Text("My Saved Recipes")
                .font(.sansBold(size: 20))
            
//            SearchBar(text: $rVM.searchText) {
//                rVM.updateRecipesList()
//            }.padding(.bottom)
        }
    }
    
    
    func myRecipesList() -> some View{
        
        ScrollView{
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                
                    ForEach(Array(rVM.recipesToShow.enumerated()), id: \.element.id) { index, element in
                    NavigationLink{
                        RecipeDetailView(recipe: $rVM.recipesToShow[index])
                    }label: {
                        RecipeCardView(recipe: $rVM.recipesToShow[index]) { isSaved in
                            let recipe_id = rVM.recipesToShow[index].id
                            Task{
                                async let savedOrUnsaved : Bool = rVM.saveRecipe(recipe_id: recipe_id, isSaved: isSaved)
                                if await savedOrUnsaved{
                                    rVM.recipesToShow.remove(at: index)
                                }
                                
                            }
                        }
//                        RecipeCard(recipe: rVM.recipesToShow[index])
                    }
                }
            }
        }
    }
    

}

extension SavedRecipesView{
    func placeHolder() -> some View{
        VStack{
            Spacer()
            HStack{
                Spacer()
                ImageName.noRecipePlaceholder
                Spacer()
            }
            HStack{
                Spacer()
                Text("No recipes added yet!")
                    .font(.sansMedium(size: 16))
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    SavedRecipesView()
}
