//
//  HomeView.swift
//  FitMe
//
//  Created by Ali Syed on 04/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftData


var SHOULD_CALL_HOME_API = true

struct HomeView: FitMeBaseView {
    
    @Binding var tabSelection: Int
    @StateObject var viewModel = HomeViewModel()
    @State var isAPICalled = false
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        
        ZStack {
            loadView
            LoaderView(isLoading: $viewModel.showLoader)
        }        .task {
            if SHOULD_CALL_HOME_API {
                await viewModel.fetchHomeData()
                SHOULD_CALL_HOME_API.toggle()
            }
            
        }.onAppear {
//            to update goal
            viewModel.updateGoal()
        }
        
    }
}


extension HomeView {
    var loadView: some View {
        VStack{
            header()
            todayGoal()
            discoverView
            todayMealPlan
            Spacer()
        }.padding(.horizontal)
        
    }
}

extension HomeView{
    func header() -> some View{
        HStack{
            NavigationLink{
                ProfileView()
            }label: {
                
                CircularAysnImageView(url: UserDefaultManager.shared.userImage)
                    .frame(width: 40, height: 40)
                
                VStack(alignment: .leading){
                    HStack {
                        Text(UserDefaultManager.shared.get()?.name ?? "")
                            .font(.sansMedium(size: 16))
                            .foregroundStyle(.black)
                        
                        Image(systemName: "chevron.forward.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.black)
                    }
                    
                    Text("Discover and track your daily meal plan with us")
                        .font(.sansRegular(size: 10))
                        .foregroundStyle(.black)
                }
            }
            Spacer()
            NavigationLink{
                NotificationView(modelContext: modelContext)
            }label: {
                Image(systemName: "bell.fill")
                    .foregroundStyle(.black)
            }
            
        }
    }
    
    func todayGoal() -> some View{
        
        NavigationLink {
            GoalView()
        } label: {
            goalCard()
            
        }.buttonStyle(PlainButtonStyle())
        
    }
    
    func goalCard() -> some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .frame(height: 177)
                .cornerRadius(15)
                .shadow(color: .textfieldBackground, radius: 15)
            
            
            VStack(alignment: .leading){
                HStack{
                    Text("Today's Calories Intake")
                        .font(.sansMedium(size: 14.35))
                    Spacer()
                    Text("Set Goal")
                        .font(.sansMedium(size: 8.97))
                        .foregroundStyle(Color.redColor)
                }
                HStack{
                    Text("Today's Calories Goal")
                        .font(.sansRegular(size: 14))
                        .foregroundStyle(Color.redColor)
                    
                    Spacer()
                    Text("\(viewModel.userGoal?.caloriesInt ?? 0) KCAL")
                        .font(.sansRegular(size: 10))
                    
                    
                }
                ProgressView(value: Double(viewModel.todayIntake?.caloriesInt ?? 0), total: Double(viewModel.userGoal?.caloriesInt ?? 0))
                    .progressViewStyle(CustomProgressView(color: .red, height: 13))
                
                HStack (spacing: 14){
                    
                    NutrientBarView(title: "Carbs Intake", filledValue: viewModel.todayIntake?.carbohydratesInt ?? 0, totalValue: viewModel.userGoal?.carbohydratesInt ?? 0, color: .carbsColor)
                    
                    
                    NutrientBarView(title: "Fats Intake", filledValue: viewModel.todayIntake?.fatsInt ?? 0, totalValue: viewModel.userGoal?.fatsInt ?? 0, color: .fatsColor)
                    
                    NutrientBarView(title: "Protein Intake", filledValue: viewModel.todayIntake?.proteinInt ?? 0, totalValue: viewModel.userGoal?.proteinInt ?? 0, color: .proteinColor)
                    
                }
                
            }.padding(.horizontal)
        }
    }
    
    var discoverView: some View {
        
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Discover Healthy Recipes")
                    .font(.sansMedium(size: 16))
                Text("Fuel Your Body, Delight Your Taste Buds")
                    .font(.sansRegular(size: 12))
            }.foregroundStyle(.white)
                .padding([.leading, .top])
            HStack {
                Spacer()
            }
            NavigationLink {
                DiscoverView()
            } label: {
                Text("Discover")
                    .foregroundStyle(.white)
                    .font(.sansMedium(size: 11))
            }.padding([.horizontal])
                .padding([.vertical], 8)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(primaryColor)
                )
                .padding([.leading, .bottom])
        }
        
        .background(
            Image("discover")
                .resizable()
                .scaledToFill()
        )
        
    }
    
    var todayMealPlan: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Today’s Meal Plan")
                    .font(.sansMedium(size: 16))
                Spacer()
                
                Button(action: {
                    tabSelection = 1
                }, label: {
                    Text("See all")
                        .font(.sansMedium(size: 12))
                }).foregroundStyle(primaryColor)
            }
            
            if viewModel.todayRecips.isEmpty {
                emptyListView
            } else {
                GeometryReader { geometry in
                    todayMealList(geometry: geometry)
                }
            }
            
        }.padding(.top)
    }
    
    var emptyListView: some View {
        
        VStack(alignment: .center, spacing: 10) {
            Image("emptyListView")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .offset(x: 20)
            
            HStack {
                Spacer()
                Text("No today Recipe found")
                Spacer()
            }
            
        }
    }
    
    func todayMealList(geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach($viewModel.todayRecips) { recipe in
                    NavigationLink {
                        RecipeDetailView(recipe: recipe, isComeFromMealPlan: true, mealType: recipe.wrappedValue.mealType ?? "", mealDay: "today")
                    } label: {
                        RecipeCardHome(recipe: recipe, width: geometry.size.height * 0.8, height: geometry.size.height * 0.9)
                            .padding(5)
                            .frame(width: geometry.size.height * 0.8, height: geometry.size.height * 0.9)
                            
                            
                    }
                }
            }
        }
    }
}


#Preview {
    HomeView(tabSelection: .constant(1))
}
