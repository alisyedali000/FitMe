//
//  DetailsView.swift
//  FitMe
//
//  Created by Ali Syed on 01/12/2023.
//

import SwiftUI
import SlidingRuler

struct SignUpAndDetailsView: View {
    @Environment (\.dismiss) var dismiss
    
    @ObservedObject var googleAuth : GoogleAuth
    @ObservedObject var appleAuth : AppleSignIn
    @ObservedObject var authVM : AuthViewModel
    
    @StateObject var dVM = DietPreferencesViewModel()
    @StateObject var rulerVM = RulersVM()
    @State var pageSelection : Int
    
    //UserDetails
    @State var selectedGender: String = "1"
    @State var weightScale : WeightScale = .kg
    @State var heightScale : HeightScale = .cm
    @State var showCalendar = false
    var body: some View {
        ZStack{
            VStack(spacing:20){
                Bars(selection: $pageSelection).padding(.horizontal)
                
                if pageSelection == 1{
                    signUpView()
                }
                if pageSelection == 2{
                    userDetailsView()
                }
                if pageSelection == 3{
                    userDietPreferences()
                }
                
                
            }

            if showCalendar {
                DatePickerMLB(showDatePicker: $showCalendar) { date in
                    let dateString = DateManager.shared.getString(from: date)
                    let ageString = DateManager.shared.getYears(date: dateString)
                    
                    let age = Int(ageString)
                    if age >= 14 {
                        authVM.age = "\(ageString) Year(s)"

                    } else {
                        authVM.showError(message: "You must be atleast 14 years old!")
                    }
                }
            }

            
            
        }.onAppear(){
//            authVM.clearFields()
        }

    }
}

// MARK :- SignUp Screen
extension SignUpAndDetailsView{
    func signUpView() -> some View{
        VStack{
            //                Bars(selection: 1)
            
            AppLogo()
            VStack(alignment: .leading, spacing: 20){
                Text("Join the FitMe Community. Sign up to your FitMe Account")
                    .lineLimit(2)
                    .foregroundStyle(.black)
                    .font(.sansRegular(size: 16))
                    .multilineTextAlignment(.leading)
                
                ScrollView(showsIndicators: false){
                    VStack(spacing: 20){
                        CustomTextField(placeholder: "Name", image: ImageName.person, text: $authVM.name)
                        
                        CustomTextField(placeholder: "Email Address", image: ImageName.email, text: $authVM.email)
                        
                        PasswordTextField(placeHolder: "Password", image: ImageName.eye, text: $authVM.password)
                        
                        PasswordTextField(placeHolder: "Confirm Password", image: ImageName.eye, text: $authVM.confirmPassword)
                        
                        VStack(spacing:20){
                            PrivacyPolicyLink()
                            Button{

                                withAnimation {
                                    if authVM.isSignUpDataValid(){
                                        pageSelection = 2
                                    }
                                }
                                
                            }label: {
                                RedButton(title: "Sign Up")
                            }
                            
                            orView()
                            
                            SocialButtons(image: ImageName.google, title: "Sign Up with Google") {
                                googleAuth.signIn {
                                    self.dismiss()
                                }
                            }
                            SocialButtons(image: ImageName.apple, title: "Sign Up with Apple") {
                                appleAuth.signIn()
                            }
                            
                            dontHaveAccount
                        }
                    }
                }
                
            }
        }.padding(.horizontal)
    }
    func orView() -> some View {
        
        HStack {
            
            ImageName.leftLine
                .resizable()
                .scaledToFit()
                .frame(height: 2)
            
            Text("OR")
                .foregroundStyle(.black)
                .font(.sansRegular(size: 12))
            
            ImageName.rightLine
                .resizable()
                .scaledToFit()
                .frame(height: 2)
        }
    }
    var dontHaveAccount: some View {
        
        HStack {
            
            Text("Already have an account?")
                .foregroundStyle(.black)
                .font(.sansRegular(size: 14))
            
            Button {
                self.dismiss()
            } label: {
                
                Text("Login")
                    .foregroundStyle(Color.redColor)
                    .font(.sansMedium(size: 14))
            }
        }
    }
}

//MARK :- UserDetailsView
extension SignUpAndDetailsView{
    func userDetailsView() -> some View{
        VStack(alignment: .leading){
            AppLogo().padding(.vertical)
            Text("Let's Get Personal! Fill in Your Details for a Personalized Fitness Experience")
                .description()
            VStack(alignment: .leading, spacing:20){
                Text("Gender")
                    .font(.sansBold(size: 16))
                HStack{
                    SelectionButton(
                        title: "Male",
                        image: ImageName.maleGender,
                        isSelected: selectedGender == "male",
                        isSmall: false, action: {
                            authVM.gender = "male"
                            selectedGender = authVM.gender // Update selected gender
                        }
                    )
                    Spacer()
                    
                    SelectionButton(
                        title: "Female",
                        image: ImageName.femaleGender,
                        isSelected: selectedGender == "female",
                        isSmall: false,
                        action: {
                            authVM.gender = "female"
                            selectedGender = authVM.gender // Update selected gender
                            print(authVM.gender)
                        }
                    )
                    Spacer()
                    SelectionButton(
                        title: "Other",
                        image: ImageName.otherGender,
                        isSelected: selectedGender == "other",
                        isSmall: false,
                        action: {
                            authVM.gender = "other"
                            selectedGender = authVM.gender // Update selected gender
                            print(authVM.gender)
                        }
                    )
                }
                
                CustomTextField(placeholder: "Age", image: ImageName.calendar, text: $authVM.age).disabled(true).onTapGesture {
                    self.showCalendar.toggle()

                    
                }
                
                WeightAndHeightRulers(rulerVM: self.rulerVM, heightString: $authVM.height, weightString: $authVM.weight)
                
                Spacer()
                Button{
                    withAnimation {
                        if authVM.isUserDetailsValid(){
                            pageSelection = 3
                        }
                    }
                    Task{
                        async let categories : () = dVM.getFoodCategories()
                        async let dietPreference : () = dVM.getDietPreferences()
                        _ =  await [categories, dietPreference]
                        
                    }
                }label: {
                    RedButton(title: "Continue")
                }
            }
        }.padding(.horizontal)
    }
}

//MARK :- DietPreferencesView
extension SignUpAndDetailsView{
    func userDietPreferences() -> some View{
        VStack(alignment: .leading){
//            Bars(selection: 3)
            AppLogo()
            Text("Select your food dislikes and dietary preferences to filter your recipe suggestions.").description()
            ScrollView(showsIndicators: false){
                
                DietPreferencesAndFoodDislikes(dVM: self.dVM, showExpaned: false)
                Spacer()
                
                Button{
                    authVM.dietPreferenceIds = dVM.getSelectedPreferenceIds()
                    authVM.foodDislikes = dVM.selectedDislikedFoods.map { "\($0.id)" }
                    print(authVM.dietPreferenceIds.count)
                    print(authVM.foodDislikes)
                    Task{
                        if authVM.isDietPreferenceValid(){
                            if UserDefaultManager.shared.isSocialLogin(){
                                await authVM.socialEditProfile(){
                                    self.dismiss()
                                    authVM.moveToDetailsPage = false
                                }
                            }else{
                                await authVM.register(){
                                 
                                    authVM.moveToDetailsPage = false
                                    self.dismiss()
                                }
                                
                            }
                        }
                       
                    }
                }label: {
                    RedButton(title: "Continue")
                }
            }
        }.padding(.horizontal)
    }
}

#Preview {
    SignUpAndDetailsView(googleAuth: GoogleAuth(), appleAuth: AppleSignIn(), authVM: AuthViewModel(), pageSelection: 2)
}
