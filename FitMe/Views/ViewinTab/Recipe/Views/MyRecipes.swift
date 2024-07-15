//
//  MyRecipes.swift
//  FitMe
//
//  Created by Ali Syed on 07/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyRecipes: View {
    @StateObject var rVM = RecipeViewModel()
    @State var showSearches = false
    
    var body: some View {
        
        loadView
            .onAppear(){
                Task{
                    async let recipes : () = rVM.getAllRecipesByUser()
                    _ = await[recipes]
                }
            }
    }
}

// MARK: - View Extension
extension MyRecipes {
    
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


extension MyRecipes{
    func screenView() -> some View{
        VStack{
            header()
            ZStack(alignment: .bottomTrailing){
                
                if rVM.recipesToShow.count > 0{
                    
                    myRecipesList()
                    
                }else{
                    placeHolder()
                }
                
                NavigationLink{
                    AddRecipeView()
                }label: {
                    ImageName.addRecipeIcon
                        .resizable()
                        .frame(width: 56 , height: 56)
                }

            }
        }.padding(.horizontal)
    }
    
    func header() -> some View{
        VStack{
            Text("My Recipes")
                .font(.sansBold(size: 20))
            
            SearchBar(text: $rVM.searchText) {
                rVM.updateRecipesList()
            }.padding(.bottom)
        }
    }
    
    
    func myRecipesList() -> some View{
        
        ScrollView{
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
                
                    ForEach(Array(rVM.recipesToShow.enumerated()), id: \.element.id) { index, element in
                    NavigationLink{
                        RecipeDetailView(recipe: $rVM.recipesToShow[index])
                    }label: {
                        RecipeCard(recipe: rVM.recipesToShow[index])
                    }
                    
                }
            }
        }
    }
    

}

extension MyRecipes{
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
    MyRecipes()
}
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
