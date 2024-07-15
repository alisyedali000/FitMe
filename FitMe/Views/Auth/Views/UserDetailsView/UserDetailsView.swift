//
//  MeasurementsView.swift
//  FitMe
//
//  Created by Ali Syed on 30/11/2023.
//

import SwiftUI
import SlidingRuler
//struct UserDetailsView: FitMeBaseView {
//    @Binding var selection : Int
//    @StateObject var authVM = AuthViewModel()
//    @State var selectedGender: String = "1"
//    @State var weightScale : WeightScale = .kg
//    @State var heightScale : HeightScale = .cm
//    @State var showCalendar = false
//    
//
//    
//
//    
//    var body: some View {
//        
//        ZStack{
//            screenView().padding(.horizontal)
//            if showCalendar {
//                DatePickerMLB(showDatePicker: $showCalendar) { date in
//                    authVM.age = DateManager.shared.getString(from: date)
//                    print("date is: \(authVM.age)")
//                }
//            }
//        }
//
//    }
//}
//extension UserDetailsView{
//    func screenView() -> some View{
//        VStack(alignment: .leading, spacing: 20){
//            AppLogo()
//            Text("Let's Get Personal! Fill in Your Details for a Personalized Fitness Experience")
//                .description()
//            Text("Gender")
//                .font(.sansBold(size: 16))
//            HStack{
//                SelectionButton(
//                    title: "Male",
//                    image: ImageName.maleGender,
//                    isSelected: selectedGender == "1",
//                    isSmall: false, action: {
//                        authVM.gender = "1"
//                        selectedGender = authVM.gender // Update selected gender
//                    }
//                )
//                Spacer()
//                
//                SelectionButton(
//                    title: "Female",
//                    image: ImageName.femaleGender,
//                    isSelected: selectedGender == "2",
//                    isSmall: false,
//                    action: {
//                        authVM.gender = "2"
//                        selectedGender = authVM.gender // Update selected gender
//                        print(authVM.gender)
//                    }
//                )
//                Spacer()
//                SelectionButton(
//                    title: "Other",
//                    image: ImageName.otherGender,
//                    isSelected: selectedGender == "3",
//                    isSmall: false,
//                    action: {
//                        authVM.gender = "3"
//                        selectedGender = authVM.gender // Update selected gender
//                        print(authVM.gender)
//                    }
//                )
//            }
//            
//            CustomTextField(placeholder: "Age", image: "calendar", text: $authVM.age).disabled(true).onTapGesture {
//                self.showCalendar.toggle()
//            }
//            
//            HStack{
//                Text("Height")
//                    .font(.sansBold(size: 16))
//                Spacer()
//                HStack{
//                    SelectionButton(title: "CM's", image: Image(uiImage: UIImage()), isSelected: heightScale == .cm, isSmall: true) {
//                        authVM.heightScale = .cm
//                        self.heightScale = authVM.heightScale
//                    }
//                    SelectionButton(title: "Feet", image: Image(uiImage: UIImage()), isSelected: heightScale == .feet, isSmall: true) {
//                        authVM.heightScale = .feet
//                        self.heightScale = authVM.heightScale
//                    }
//                }
//            }
//            if heightScale == .cm{
//                SlidingRuler(value: $authVM.height,
//                             in: 110...190,
//                             step: 1,
//                             snap: .fraction,
//                             tick: .fraction,
//                             formatter: authVM.formatter)
//            }
//            if heightScale == .feet{
//                SlidingRuler(value: $authVM.height,
//                             in: 1...8,
//                             step: 1,
//                             snap: .fraction,
//                             tick: .fraction,
//                             formatter: authVM.formatter)
//            }
//            HStack{
//                Text("Weight")
//                    .font(.sansBold(size: 16))
//                Spacer()
//
//                HStack{
//                    SelectionButton(title: "Kg", image: Image(uiImage: UIImage()), isSelected: weightScale == .kg, isSmall: true) {
//                        authVM.weightScale = .kg
//                        self.weightScale = authVM.weightScale
//                    }
//                    SelectionButton(title: "Pounds", image: Image(uiImage: UIImage()), isSelected: weightScale == .pound, isSmall: true) {
//                        authVM.weightScale = .pound
//                        self.weightScale = authVM.weightScale
//                    }
//                }
//            }
//            SlidingRuler(value: $authVM.weight,
//                               in: 30...400,
//                               step: 1,
//                               snap: .fraction,
//                               tick: .fraction,
//                         formatter: authVM.formatter)
//            Spacer()
//            Button{
//                withAnimation {
//                    selection = 3
//                }
//            }label: {
//                RedButton(title: "Continue")
//            }
//        }
//    }
//
//}


