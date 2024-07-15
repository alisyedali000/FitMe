//
//  RecipeDetailView.swift
//  FitMe
//
//  Created by Ali Syed on 12/12/2023.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI



struct RecipeDetailView: FitMeBaseView {
    
    @Binding var recipe: RecipeModel
    
    @State var totalHeight  = CGFloat.zero
    @State var deleteRecipeAlert = false
    @State private var isAddMealSheetOpen = false
    @State private var showDeleteFromMealPlanAlert = false
    
    var isComeFromMealPlan = false
    var mealType = ""
    var mealDay = ""
    
    @StateObject var viewModel = RecipeDetailViewModel()
    @Environment (\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    
    
    
    var body: some View {
        ZStack{
            
            screenView()
            LoaderView(isLoading: $viewModel.showLoader)
        }
        .navigationTitle("")
        .toolbarRole(.editor)
        .navigationBarItems(trailing: HStack{
            
            //             show only edit opetions to the creator of the application.
            if recipe.userID == String(UserDefaultManager.shared.userId) {
                recipeCreatorToolBar
            }
            
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if isComeFromMealPlan && !mealDay.isEmpty {
                    deleteFromMealPlan
                }
            }
        }
        .alert("Fit me", isPresented: $showDeleteFromMealPlanAlert, actions: {
            Button {
                Task {
                    if (await viewModel.requestDeleteFromMealPlan(recipe_id: recipe.idString, mealType: mealType, mealDay: mealDay)) {
                        SHOULD_CALL_HOME_API = true
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
            } label: {
                Text("Ok")
                    
            }
            Button {
                showDeleteFromMealPlanAlert.toggle()
            } label: {
                Text("Cancel")
            }

        }, message: {
            Text("Are you sure, you want to delete \(recipe.name) from your meal plane")
        })
        .alert(viewModel.isSuccess ? "Fit me" : "Error", isPresented: $viewModel.showError, actions: {
            Button {
                if viewModel.isSuccess {
                    self.presentationMode.wrappedValue.dismiss()
                    viewModel.isSuccess = false
                }
                
            } label: {
                Text("Ok")
            }

        }, message: {
            Text(viewModel.errorMessage)
        })
        .alert(isPresented: $deleteRecipeAlert) {
            Alert(
                title: Text("Delete Recipe"),
                message: Text("Are you sure you want to delete this recipe?"),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        await viewModel.deleteRecipe(recipe_id: String(recipe.id))
                        self.presentationMode.wrappedValue.dismiss()
                    }
                },
                secondaryButton: .cancel(Text("Cancel")) {
                    deleteRecipeAlert = false
                }
            )
        }
        .sheet(isPresented: $isAddMealSheetOpen, content: {
            MealTypeSelectionSheet(mealTimeSelection: $viewModel.mealSelectionTime,
                                   mealTypeSelection: $viewModel.mealSelectionType,
                                   selectedItems: $viewModel.selectedDays, addMealAction: {
                Task {
                    await viewModel.requestAddRecipeToMealPlan(recipe: recipe)
                    SHOULD_CALL_HOME_API = true
                }
            })
        })
    }
}
extension RecipeDetailView{
    
    
    var recipeCreatorToolBar: some View {
        Menu {
            NavigationLink{
                EditRecipeView(recipe: $recipe)
            }label: {
                Text("Edit")
            }
            
            Button{
                self.deleteRecipeAlert.toggle()
            }label: {
                Text("Delete")
            }
            
        } label: {
            ImageName.menuDots
                .renderingMode(.template)
                .foregroundStyle(.white)
        }
        .background(
            BlurRectangle(opcity: 0.8, color: primaryColor)
                .offset(x: 3)
        )
    }
    
    var deleteFromMealPlan: some View {
        Button {
            showDeleteFromMealPlanAlert.toggle()
        } label: {
            Image(systemName: "trash")
        }
        .foregroundStyle(.white)
        .background(
            BlurRectangle(opcity: 0.8, color: primaryColor)
        )

    }
    
    
    func screenView()->some View{
        VStack {
            GeometryReader { geo in
                ScrollView {
                    VStack{
                        RectangleAysnImageView(url: recipe.image, showOverlay: false)
                            .scaledToFill()
                            .frame(width:geo.size.width, height: geo.size.height * 0.40)
                        
                    }.edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        HStack{
                            VStack(alignment: .leading,spacing: 10){
                                HStack{
                                    Text(recipe.name )
                                        .font(.sansMedium(size: 20))
                                    Spacer()
                                    VStack {
                                        
                                        if isComeFromMealPlan {
                                            mealTypeBanner
                                        }
                                        HStack {
                                            Image(systemName: "clock.fill")
                                                .resizable()
                                                .foregroundStyle(Color.grayImages)
                                                .frame(width: 10, height: 10)
                                            
                                            Text("\(recipe.minutes ) Min(s)")
                                                .font(.sansRegular(size: 10))
                                                .foregroundStyle(Color.grayImages)
                                        }
                                    }
                                   
                                }
                                Text("Serves \(recipe.serves) | \(recipe.foodPreferences.map { $0.name }.joined(separator: ", ")) | \(recipe.difficulty)")
                                    .font(.sansRegular(size: 13))
                                    .foregroundStyle(Color.grayImages)
                                
                                addedBy
                                
                                DonutChart(details: $recipe)
                                
                                
                                Text("Recipe Ingredients")
                                    .font(.sansMedium(size: 14))
                                //
                                
                                TagView(tags: .constant(recipe.ingredientsString), action: { _ in })
                                
                                Text("Method")
                                    .font(.sansMedium(size: 14))
                                Text(recipe.method)
                                    .font(.sansRegular(size: 10))
                                
                                bottomButtons
                            }
                            Spacer()
                            
                        }
                    }.padding(.horizontal).padding(.top,20).background(Color.white)
                        .cornerRadius(31).offset(y:-35)
                    
                }
            }.ignoresSafeArea(edges: .top)
            
        }
    }
    
    var mealTypeBanner: some View {
        Text(recipe.mealType ?? "")
            .font(.sansRegular(size: 12))
            .foregroundStyle(.yellow)
            .padding(5)
            .background(
                BlurRectangle(opcity: 0.2, color: .yellow)
            )
    }
    
    var bottomButtons: some View {
        isComeFromMealPlan ? AnyView(addToShoppingListButton) :
        AnyView(addToMealButton)

        
    }
    
    
    var addToMealButton: some View {
        CustomButton(title: "Add to meal plan") {
            isAddMealSheetOpen.toggle()
        }.padding(.top)
    }
    
    var addToShoppingListButton: some View {
        VStack {
            VStack {
                CustomButton(title: "Add to shopping list", makeStrokButton: true) {
                    
                    viewModel.isSuccess = true
                    
                    self.addToShoppingList()
                    
//                    viewModel.isSuccess = false
                }
                if mealDay == TODAY.lowercased() {
                    foodTakenSkipButton
                }
            }
    
        }
    }
    
    var addedBy: some View {
        HStack {

            recipe.addedByDetail.name.lowercased() == "fitme" ?
            AnyView(Image("AppLogo")
                .frame(width: 47, height: 47)
                .scaledToFill()
                .clipped()
            )
            :
            AnyView(CircularAysnImageView(url: recipe.addedByDetail.image, showOverlay: false)
                .frame(width: 47, height: 47)
                .scaledToFit())
            
            VStack(alignment: .leading) {
                Text("Created By")
                    .font(.sansRegular(size: 11))
                    .foregroundStyle(primaryColor)
                Text(recipe.addedByDetail.name)
                    .font(.sansRegular(size: 14))
            }
            
            Spacer()
        }.padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(textFieldColor)
            )
    }
    
    
    var foodTakenSkipButton: some View {
        HStack {
            foodTakenButton
            foodSkippedButton
        }
    }
    
    var foodTakenButton: some View {
        
        recipe.foodEaten == 0 ? AnyView(
            CustomButton(title: "Mark as eaten") {
                Task {
                    if  (await viewModel.requestRecipeTaken(recipe_id: String(recipe.id), eatenStatus: "1", meal_type: mealType)) {
                        recipe.foodEaten = 1
                        recipe.foodSkipped = 0
                    }
                }
                
            }.disabled(recipe.foodSkipped == 1)
        )
        : AnyView(
            Button(action: {
                //            show message food is alrady taken
                viewModel.showError(message: "Alreay taken \(recipe.name)")
            }, label: {
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(primaryColor.opacity(0.2))
                        .frame(height: 46)
                    
                    Text("Alreay taken")
                        .foregroundStyle(primaryColor)
                        .font(.sansRegular(size: 16))
                }
            })
        )
    }
    
    var foodSkippedButton: some View {
        CancelButton(title: recipe.foodSkipped == 1 ? "Alreay skipped" : "Mark as skipped") {
            
            if recipe.foodSkipped == 1 {
                viewModel.showError(message: "Alreay skipped \(recipe.name)")
            } else {
                Task {
                    if (await viewModel.requestRecipeTaken(recipe_id: String(recipe.id), eatenStatus: "2", meal_type: mealType)) {
                        recipe.foodSkipped = 1
                        recipe.foodEaten = 0
                    }
                }
            }
            
            
        }.disabled(recipe.foodEaten == 1)
    }
}

// MARK: Custom Function Extension
extension RecipeDetailView {
    func addToShoppingList() {
        
        if recipe.ingredients.isEmpty {
            viewModel.showError(message: "No Ingredient founded")
            return
        }
        
        for ingredient in recipe.ingredients {
            let shoppingItem = ShoppingItem(id: UUID(),
                                            quantitly: ingredient.quantity,
                                            name: ingredient.name, measuringUnit: ingredient.scale, isChecked: false, createAt: Date(),
                                                recipeID: recipe.id)
            modelContext.insert(shoppingItem)
        }
        
        viewModel.showError(message: "Shopping list Added Successfully")
        
    }
}


#Preview {
    RecipeDetailView(recipe: .constant(mockRecipes.first!))
}
