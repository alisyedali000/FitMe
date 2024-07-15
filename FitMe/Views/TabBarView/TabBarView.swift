//
//  TabBarView.swift
//  FitMe
//
//  Created by Ali Syed on 05/12/2023.
//
import SwiftUI

struct TabBarView: View {
   
    
    @Environment(\.modelContext) var modelContext
    @State private var tabSelection = 0
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().unselectedItemTintColor = .gray
        UITabBar.appearance().backgroundColor = UIColor(Color.TabBarBGColor)
        UITabBar.appearance().tintColor = UIColor(Color.redColor)
        
    }
    
    
    var body: some View {
        TabView(selection: $tabSelection) {
            
            HomeView(tabSelection: $tabSelection)
                .tabItem {
                    
                    withAnimation(.linear(duration: 0.5)) {
                        Label("Home", image: tabSelection == 0 ? ImageName.homeSelected.rawValue : ImageName.home.rawValue)
                     
                    }
                }
                .tag(0)
            
            MealPlannerView()
                .tabItem {
                    withAnimation(.linear(duration: 0.5)) {
                        
                        Label("Meal Planner", image: tabSelection == 1 ? ImageName.mealPlannerSelected.rawValue : ImageName.mealPlanner.rawValue)
                    }
                }
            
                .tag(1)
            ShoppingListView(modelContext: modelContext)
                .tabItem {
                    withAnimation(.linear(duration:0.5)){
                        Label("Shopping List", image: tabSelection == 2 ? ImageName.shoppingListSelected.rawValue : ImageName.shoppingList.rawValue)
                    }
                }
                .tag(2)
            
            MyRecipes()
                .tabItem {
                    withAnimation(.linear(duration:0.5)){
                        Label("Recipes", image: tabSelection == 3 ? ImageName.recipesSelected.rawValue : ImageName.recipes.rawValue)
                    }
                }
                .tag(3)
            
            
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PushNotification"))) { _ in

            tabSelection = 3
        }
        .accentColor(.redColor)
        
            .navigationBarHidden(true)
//            .onAppear(){
//                authVM.clearFields()
//            }
    }
}

#Preview {
    TabBarView()
}
