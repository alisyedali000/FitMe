//
//  EditProfileView.swift
//  FitMe
//
//  Created by Ali Syed on 06/12/2023.
//

import SwiftUI
import SDWebImage
import SlidingRuler

struct EditProfileView: View {
    @StateObject var profileVM : ProfileViewModel
    @StateObject var rulerVM = RulersVM()
    @Environment (\.presentationMode) var presentationMode
    @State var weightScale : WeightScale = .kg
    @State var heightScale : HeightScale = .cm
    @State var showCalendar = false
    var body: some View {
        ZStack{
            screenView()
            
//            if showCalendar {
//                DatePickerMLB(showDatePicker: $showCalendar) { date in
//                    profileVM.age = DateManager.shared.getString(from: date)
//                    profileVM.age = DateManager.shared.getYears(date: profileVM.age)
//                    print("date is: \(profileVM.age)")
//                }
//            }
            if showCalendar {
                DatePickerMLB(showDatePicker: $showCalendar) { date in
                    let dateString = DateManager.shared.getString(from: date)
                    let ageString = DateManager.shared.getYears(date: dateString)
                    
                    let age = Int(ageString)
                    if age >= 14 {
                        profileVM.age = "\(ageString) Year(s)"
                    } else {
                        profileVM.showError(message: "You must be atleast 14 years old!")
                    }
                }
            }

            
            LoaderView(isLoading: $profileVM.showLoader)
        }.navigationTitle("Edit Profile").toolbarRole(.editor).onAppear(){
            profileVM.name = profileVM.userDetails?.name ?? ""
            profileVM.age = profileVM.userDetails?.age ?? ""
            profileVM.height = profileVM.userDetails?.height ?? ""
            profileVM.weight = profileVM.userDetails?.weight ?? ""
            rulerVM.height = rulerVM.extractValAndSetScale(from: profileVM.height)
            rulerVM.weight = rulerVM.extractValAndSetScale(from: profileVM.weight)
        }.alert("FitMe", isPresented: $profileVM.showError) {
            Button("OK"){
                if profileVM.isSuccess{
                    profileVM.isSuccess = false
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text(profileVM.errorMessage)
        }


    }
}
extension EditProfileView{
    func screenView() -> some View{
        VStack(spacing : 20){

            CustomTextField(placeholder: "Name", image: ImageName.person, text: $profileVM.name)
            CustomTextField(placeholder: "Age", image: ImageName.calendar, text: $profileVM.age).disabled(true).onTapGesture {
                self.showCalendar.toggle()
            }
            
            WeightAndHeightRulers(rulerVM: self.rulerVM, heightString: $profileVM.height, weightString: $profileVM.weight)
            
            Spacer()
            
            Button{
                Task{
                    if profileVM.isEditProfileDataValid(){
                        await profileVM.editProfile()
                    }
                }
            }label: {
                RedButton(title: "Done")
            }
                
        }.padding(.horizontal)
    }
    

}
#Preview {
    EditProfileView(profileVM: ProfileViewModel())
}
