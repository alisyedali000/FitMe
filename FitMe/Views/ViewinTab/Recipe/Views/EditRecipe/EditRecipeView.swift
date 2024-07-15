//
//  EditRecipeView.swift
//  FitMe
//
//  Created by Ali Syed on 12/12/2023.
//
import SDWebImageSwiftUI
import SwiftUI
struct EditRecipeView: View {

    @Environment (\.presentationMode) var presentationMode
    @StateObject var rVM: EditRecipeViewModel

    @StateObject var dVM = DietPreferencesViewModel()
    
    @State private var isPreferenceShown = false
    
    @State var getImage = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var pickedImage : UIImage?
    @State var openConfirmationDialog = false
    @State var shouldReload = true
    @State var tempImageData = ""
    @Binding var recipe: RecipeModel {
        didSet {
              debugPrint("Recipe updated:", recipe)
          }
    }
    
    init(recipe: Binding<RecipeModel>) {
        _recipe = recipe
        _rVM = StateObject(wrappedValue: EditRecipeViewModel(recipe: recipe.wrappedValue))
    }

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
                
        }
        .navigationTitle("Edit Recipe").toolbarRole(.editor).onAppear(){
            Task{
                if shouldReload{
                    async let preference : () = rVM.getDietPreferences()
                    async let categories : () = rVM.getFoodCategories()
                    _ = await[preference, categories]
                    
                }
            }
        }
        .onReceive(rVM.$isSuccess, perform: { newValue in
            if newValue {
                if let updatedRecipeModel = rVM.updatedRecipeModel {
                    self.recipe = updatedRecipeModel
                }
                self.presentationMode.wrappedValue.dismiss()
            }
        })
            
    }
}


extension EditRecipeView{
    func screenView() -> some View{
        VStack(spacing : 10){
            ScrollView(showsIndicators: false){
                VStack{
                    if let image = pickedImage {
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 212)
                            .clipped()
                            .cornerRadius(12.0)
                            .clipShape(.rect)
                    }else{
                        WebImage(url: URL(string: AppUrl.IMAGEURL + (rVM.recipe.image)))
                            .onSuccess { image, data, cacheType in
                                rVM.showLoader = false
                                tempImageData = image.resizedTo1MB()?.base64 ?? ""
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(height: 212)
                            .clipped()
                            .cornerRadius(12.0)
                            .clipShape(.rect)
                            
                    }
                }.overlay(
                    uploadBanner().offset(x:130, y: -50)
                )
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
                
                SimpleTextField(placeholder: "No. of servings", value: $rVM.recipe.serves)
                
                DropDownButton(title: "Preference \(rVM.selectedPreferencesNames.count == 0 ? "" : String(rVM.selectedPreferencesNames.count))", isShown: $isPreferenceShown)
                if isPreferenceShown {
                    GenericMultiListSelection(list: rVM.preferenceOptions, selectedItems: $rVM.selectedPreferencesNames)
                }
                
                SimpleTextField(placeholder: "Enter no of calories", value: $rVM.recipe.calories)
                
                caloriesSliders()
                
                
                HStack{
                    Text("Recipe Ingredients")
                        .font(.sansMedium(size: 16))
                    Spacer()
                    NavigationLink{
                        AddIngredientsView(dVM: self.dVM, shouldReload: $shouldReload, recipeIngredients: $rVM.recipeIngredients)
                    }label: {
                        Image(systemName: "plus")
                    }
                }.padding(.bottom,20)
                
                VStack {
                    ForEach(rVM.recipeIngredients.indices, id: \.self) { index in
                        IngredientRowView(ingredient: $rVM.recipeIngredients[index], crossAction: {
                            dVM.selectedDislikedFoods.removeAll {$0.id == rVM.recipeIngredients[index].id}
                            rVM.recipeIngredients.removeAll { $0.id == rVM.recipeIngredients[index].id }
                        })
                    }

                }
                
                VStack(alignment: .leading){
                    Text("Methods")
                        .font(.sansMedium(size:14))
                    CustomTextEditor(text: $rVM.recipe.method, placeholder: "Add instructions ...", height: 120.0).padding(.vertical,20)
                }
                
                Button{
              
                    if pickedImage == nil {
                        rVM.recipe.image = tempImageData
                    }
                    
                    if (rVM.validateRecipe()){
                        Task {
                            await rVM.requestEditRecipe()
                        }
                    }
                }label: {
                    RedButton(title: "Edit Recipe")
                }
                
                CancelButton(title: "Cancel") {
                    
                }
                
            }.addDoneButton.padding(.horizontal)
                
        }
}
    
    
    func caloriesSliders() -> some View{
        VStack(spacing : 20){
            VStack{
                sliderHeading(title: "Carbohydrates", value: Int(rVM.carbohydrates))
                Slider(value: $rVM.carbohydrates,
                       in: 0...1000,
                       step: 1)
                
            }
            VStack{
                sliderHeading(title: "Protein", value: Int(rVM.protein))
                Slider(value: $rVM.protein,
                       in: 0...1000,
                       step: 1)
                
            }
            VStack{
                sliderHeading(title: "Fats", value: Int(rVM.fats))
                Slider(value: $rVM.fats,
                       in: 0...1000,
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
    
    func uploadBanner() -> some View{
        
        
        HStack{
            Button{
                self.openConfirmationDialog.toggle()
            }label: {
                ImageName.addImageIcon
            }
            
        }.padding(10)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.black)
                .opacity(0.5)
        }
        
    }
}

// MARK: Custom funstion extension
extension EditRecipeView {
    func updateBindingRecipe() {
        
    }
    
}

#Preview {
    EditRecipeView(recipe: .constant(mockRecipes.first!))
}
