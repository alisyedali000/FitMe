//
//  AddRecipeView.swift
//  FitMe
//
//  Created by Ali Syed on 07/12/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddRecipeView: View {
    @Environment (\.presentationMode) private var presentationMode
    @StateObject var rVM = RecipeViewModel()
    @StateObject var dVM = DietPreferencesViewModel()

    @State private var isPreferenceShown = false
    @State var getImage = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var pickedImage = UIImage(named: ImageName.addRecipeImage.rawValue)
    @State var openConfirmationDialog = false
//    @State var sliderValue = 0.0
    var body: some View {
        ZStack{
            screenView()
            LoaderView(isLoading: $rVM.showLoader)
                .alert("FitMe", isPresented: $rVM.showError){
                    Button("OK"){
                        if rVM.isSuccess{
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }message: {
                    Text(rVM.errorMessage)
                }
                .fullScreenCover(isPresented: $getImage) {
                    ImagePickerView(allowsEditing: false, sourceType: sourceType) { image, _ in
                        pickedImage = image
                        rVM.recipe.image = image.resizedTo1MB()?.base64 ?? ""
                    }.ignoresSafeArea(.all)
                    
                }
                .confirmationDialog("Choose... ", isPresented: $openConfirmationDialog) {
                    
                    Button("Camera") {
                        self.sourceType = .camera
                        self.getImage.toggle()
                    }
                    
                    Button("Gallery") {
                        self.sourceType =  .photoLibrary
                        self.getImage.toggle()
                    }
                    
                }
                
        }.navigationTitle("Add Recipe").toolbarRole(.editor).addDoneButton.onAppear(){
            Task{
                async let preference : () = rVM.getDietPreferences()
                async let categories : () = rVM.getFoodCategories()
                _ = await[preference, categories]
            }
        }
            
    }
}


extension AddRecipeView{
    func screenView() -> some View{
        VStack(spacing : 10){
            ScrollView(showsIndicators: false){
                
                Image(uiImage: pickedImage!)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 212)
                    .clipped()
                    .cornerRadius(12.0)
                    .clipShape(.rect).overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 82)
                            .foregroundColor(.black)
                            .opacity(0.5)
                            .padding(.horizontal).overlay(
                                HStack{
                                    Text("Upload Image")
                                        .font(.sansMedium(size: 16))
                                        .foregroundColor(.white)
                                        .padding(.horizontal,30)
                                    Spacer()
                                    ImageName.addImageIcon
                                        .padding(.trailing,30)
                                    
                                }
                            )
                            .opacity(pickedImage == UIImage(named: ImageName.addRecipeImage.rawValue) ? 1.0 : 0.0)
                        
                    ).onTapGesture {
                        self.openConfirmationDialog.toggle()
                    }
                
                SimpleTextField(placeholder: "Recipe Name...", value: $rVM.recipe.name)
                
                HStack(spacing: 15){
                    
                    SimpleTextField(placeholder: "90", value: $rVM.recipe.minutes).keyboardType(.numberPad).overlay(
                        HStack{
                            Spacer()
                            Text("Mins")
                                .font(.sansRegular(size: 14))
                                .padding(.trailing)
                        }
                    )
                    
                    StringDropDown(placeholder: "Difficulty", menuOptions: rVM.difficultyOptions, selectedOption: $rVM.recipe.difficulty)
                }
                
                
                
                HStack(spacing: 15){
                    SimpleTextField(placeholder: "No. of servings", value: $rVM.recipe.serves).keyboardType(.numberPad)

                }

                DropDownButton(title: "Preference \(rVM.selectedPreferencesNames.count == 0 ? "" : String(rVM.selectedPreferencesNames.count))", isShown: $isPreferenceShown)
                
                if isPreferenceShown {
                    GenericMultiListSelection(list: rVM.preferenceOptions, selectedItems: $rVM.selectedPreferencesNames)
                }
                
                SimpleTextField(placeholder: "Enter no of calories", value: $rVM.recipe.calories).keyboardType(.numberPad)
                
                caloriesSliders()
                
//                CustomDropDown(placeholder: "Recipe Category", menuOptions: rVM.recipeCategoryOtions, selectedOption: $rVM.selectedPreference)
                
                HStack{
                    Text("Recipe Ingredients")
                        .font(.sansMedium(size: 16))
                    Spacer()
                    NavigationLink{
                        AddIngredientsView(dVM: self.dVM, shouldReload: .constant(false), recipeIngredients: $rVM.recipeIngredients)
                    }label: {
                        Image(systemName: "plus")
                    }
                }.padding(.bottom,20)
                
                VStack {
                    ForEach(rVM.recipeIngredients.indices, id: \.self) { index in
                        IngredientRowView(ingredient: $rVM.recipeIngredients[index], crossAction: {
                            dVM.selectedDislikedFoods.removeAll {$0.id == rVM.recipeIngredients[index].id}
                            rVM.recipeIngredients.removeAll { $0.id == rVM.recipeIngredients[index].id }
                        }).keyboardType(.numberPad)
                    }
                    
                    
                }
                
                VStack(alignment: .leading){
                    Text("Methods")
                        .font(.sansMedium(size:14))
                    CustomTextEditor(text: $rVM.recipe.method, placeholder: "Add instructions ...", height: 120.0).padding(.vertical,20)
                }
                
                Button{
                    
                    if rVM.validateRecipe(){
                        Task{
                            await rVM.addRecipe()
                        }
                    }
                }label: {
                    RedButton(title: "Add Recipe")
                }
                
                CancelButton(title: "Cancel") {
                    
                }
            }.padding(.horizontal)
        }
        
    
}
    
    
    func caloriesSliders() -> some View{
        VStack(spacing : 20){
            VStack{
                sliderHeading(title: "Carbohydrates", value: Int(rVM.carbohydrates))
                Slider(value: $rVM.carbohydrates,
                       in: 0...300,
                       step: 1)

            }
            VStack{
                sliderHeading(title: "Protein", value: Int(rVM.protein))
                Slider(value: $rVM.protein,
                       in: 0...300,
                       step: 1)

            }
            VStack{
                sliderHeading(title: "Fats", value: Int(rVM.fats))
                Slider(value: $rVM.fats,
                       in: 0...300,
                       step: 1)

            }
        }.padding(.leading,10)
    }
    func sliderHeading(title : String, value: Int) -> some View{
        HStack{
            Text(title)
                .font(.sansMedium(size: 16))
            Spacer()
            Text("\(value)g")
                .font(.sansBold(size: 16))
        }
        
    }
}



#Preview {
    AddRecipeView()
}
