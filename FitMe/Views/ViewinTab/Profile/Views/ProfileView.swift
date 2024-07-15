//
//  ProfileView.swift
//  FitMe
//
//  Created by Ali Syed on 05/12/2023.
//

import SwiftUI
import SwiftData
import SDWebImageSwiftUI


struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.modelContext) var modelContext
    
    
    @EnvironmentObject var authVM : AuthViewModel
    @StateObject var profileVM = ProfileViewModel()
    @EnvironmentObject var appleAuth : AppleSignIn
    @EnvironmentObject var googleAuth : GoogleAuth
    @State var deleteAccountAlert = false
    @State var toggleState = true
    @State private var isCallingApiFirstTime = false
    
    //ProfilePic
    
    @State var getImage = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var pickedImage = UIImage(named: ImageName.profileAvatar.rawValue)
    @State var openConfirmationDialog = false
    @State var url = ""
    
    var body: some View {
        ZStack{
            screenView()
            LoaderView(isLoading: $profileVM.showLoader)
        }
        .navigationTitle("Profile").toolbarRole(.editor)
        .onAppear(){
            Task{
                profileVM.userDetails = UserDefaultManager.shared.get()
            }
        }
        .alert(isPresented: $deleteAccountAlert) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete Your Account, your account will be deleted permanently?"),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        await profileVM.deleteAccount(){
                            googleAuth.deleteUser()
                            googleAuth.signOut()
                            appleAuth.signOut()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                },
                secondaryButton: .cancel(Text("Cancel")) {
                    deleteAccountAlert = false
                }
            )
        }
        
        .fullScreenCover(isPresented: $getImage) {
            ImagePickerView(allowsEditing: false, sourceType: sourceType) { image, _ in
                pickedImage = image
                profileVM.base64Image = image.resizedTo1MB()?.base64 ?? ""
                Task {
                    await profileVM.updateProfilePicture()
                    await profileVM.getProfileDetails()
                    profileVM.imageURL = AppUrl.IMAGEURL + (profileVM.userDetails?.profilePic ?? "")
                }
                
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
}
extension ProfileView{
    
    func screenView() -> some View{
        VStack(spacing:30){
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 121)
                .foregroundStyle(Color.profileHeaderBG)
                .overlay(
                    profileHeader()
                )
            
            
            VStack(spacing:20){
                NavigationLink{
                    SavedRecipesView()
                }label: {
                    profileLog(title: "Saved Recipe", description: "Access your bookmarked recipes.", image: ImageName.savedRecipesLog, isBold: false, isToggleRequired: false)
                }
                NavigationLink{
                    MyPreferencesView()
                }label: {
                    profileLog(title: "My Preferences", description: "Modify your dislikes and preferences.", image: ImageName.preferenceLog, isBold: false, isToggleRequired: false)
                }
                profileLog(title: "Notifications", description: "Control your notification settings.", image: ImageName.notificationLog, isBold: false, isToggleRequired: true)
                
                if !UserDefaultManager.shared.isSocialLogin(){
                    NavigationLink{
                        ChangeEmailView(profileVM: self.profileVM)
                    }label: {
                        profileLog(title: "Change Email", description: "Update your email address.", image: ImageName.changeEmailLog, isBold: false, isToggleRequired: false)
                    }
                    NavigationLink{
                        ChangePasswordView(profileVM: self.profileVM)
                    }label: {
                        profileLog(title: "Change Password", description: "Modify your account password.", image: ImageName.changePasswordLog, isBold: false, isToggleRequired: false)
                    }
                }
                
                Button{
                    
                }label: {
                    profileLog(title: "Privacy Policies", description: "Learn about data protection.", image: ImageName.privacyPoliciesLog, isBold: false, isToggleRequired: false)
                }
                Button{
                    self.deleteAccountAlert = true
                }label: {
                    profileLog(title: "Delete Account", description: "Permanently remove your account.", image: ImageName.deleteAccountLog, isBold: true, isToggleRequired: false)
                }
                
            }
            Spacer()
            
            Button{
                Task{
                        profileVM.logout(modelContext: modelContext)
                        appleAuth.signOut()
                        googleAuth.signOut()
                        self.presentationMode.wrappedValue.dismiss()
                    
                }
                
                
                
            }label: {
                RedButton(title: "Logout")
            }
            
        }.padding(.horizontal)
    }
    func profileHeader() -> some View{
        VStack{
            HStack(spacing: 20){
                ZStack{
                    CircularAysnImageView(url: UserDefaultManager.shared.userImage)
                        .frame(width: 40, height: 40)
                    
                }.onTapGesture {
                    self.openConfirmationDialog.toggle()
                }
                VStack(alignment : .leading){
                    Text(UserDefaultManager.shared.get()?.name ?? "Username")
                        .font(.sansMedium(size: 16))
                    Text(UserDefaultManager.shared.get()?.email ?? "user@gmail.com")
                        .foregroundStyle(Color.grayImages)
                        .font(.sansRegular(size: 10))
                }
                Spacer()
                NavigationLink{
                    EditProfileView(profileVM: self.profileVM)
                }label: {
                    ImageName.editProfileIcon
                        .resizable()
                        .frame(width: 30, height: 30)
                }
            }
            
            HStack{
                roundedRectangle(title: "Weight", value: profileVM.userDetails?.weight ?? "", image: ImageName.dumbell.rawValue)
                Spacer()
                roundedRectangle(title: "Height", value: profileVM.userDetails?.height ?? "", image: ImageName.ruler.rawValue)
                Spacer()
                roundedRectangle(title: "Gender", value: profileVM.userDetails?.gender ?? "", image:( profileVM.userDetails?.gender ?? "male" == "male" ) ? "male" : "female")
                Spacer()
                roundedRectangle(title: "Age", value: profileVM.userDetails?.age ?? "", image: ImageName.calendarRed.rawValue)
            }
        }.padding(.horizontal)
    }
    
    
    func roundedRectangle(title: String, value: String, image : String) -> some View{
        HStack{
            RoundedRectangle(cornerRadius: 6)
                .frame(height: 33)
                .foregroundStyle(.white)
                .overlay(
                    HStack{
                        VStack{
                            Image(image)
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                        VStack{
                            Text(title)
                                .font(.sansRegular(size: 12))
                            Text(value)
                                .font(.sansRegular(size: 7.17))
                                .foregroundStyle(Color.profileHeaderAttributes)
                        }
                    }
                )
        }
    }
    
    
    func profileLog(title: String, description: String, image: Image, isBold : Bool , isToggleRequired: Bool) -> some View{
        HStack{
            image
                .resizable()
                .frame(width: 40, height: 40)
            VStack(alignment: .leading){
                Text(title)
                    .foregroundStyle(isBold ? .red : .black)
                    .font(isBold ? .sansMedium(size: 16) : .sansRegular(size: 16))
                Text(description)
                    .foregroundStyle(Color.grayImages)
                    .font(.sansRegular(size: 10))
            }
            
            Spacer()
            if (isToggleRequired){
                Toggle("", isOn: $toggleState).tint(Color.redColor)
            }else{
                Image(systemName: "chevron.right")
                    .foregroundStyle(.black)
            }
            
        }
    }
}
#Preview {
    ProfileView()
}

