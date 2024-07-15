//
//  CustomImages.swift
//  FitMe
//
//  Created by Taimoor Arif on 20/11/2023.
//

import Foundation
import SwiftUI

enum ImageName: String {
    
    static var splashImage: Image {
        Image("splash_image")
    }
    
    static var google: Image {
        Image("google")
    }
    
    static var appLogo: Image {
        Image("AppLogo")
    }
    
    static var leftLine: Image {
        Image("leftLine")
    }
    
    static var rightLine: Image {
        Image("rightLine")
    }
    static var apple: Image {
        Image("apple")
    }
    
    // Gender Specification
    
    static var maleGender: Image {
        Image("maleGender")
    }
    static var femaleGender: Image {
        Image("femaleGender")
    }
    static var otherGender: Image {
        Image("otherGender")
    }
    
    //TextFields
    
    static var email: Image {
        Image("Letter")
    }
    static var eye: Image {
        Image("Eye")
    }
    static var person: Image {
        Image("user")
    }
    static var calendar: Image {
        Image("Calendar")
    }
    static var eyeClosed: Image {
        Image("EyeClosed")
    }
    
    // Profile
    static var savedRecipesLog: Image {
        Image("savedRecipes")
    }
    static var preferenceLog: Image {
        Image("preference")
    }
    static var notificationLog: Image {
        Image("notification")
    }
    static var changeEmailLog: Image {
        Image("changeEmail")
    }
    static var changePasswordLog: Image {
        Image("changePassword")
    }
    static var privacyPoliciesLog: Image {
        Image("privacyPolicies")
    }
    static var deleteAccountLog: Image {
        Image("deleteAccount")
    }
    static var editProfileIcon: Image {
        Image("editProfile")
    }
    
    case dumbell = "Dumbbell Small"
    case ruler = "Ruler"
    case calendarRed = "Calendar"
    case genderMale = "Men"
    
    case female = "female"
    case male = "male"
    
    case messageImg = "envelope.fill"
    
    // TabBar
    case homeSelected = "homeSelected"
    case home = "home"
    case mealPlanner = "mealPlanner"
    case mealPlannerSelected = "mealPlannerSelected"
    case shoppingList = "shoppingList"
    case shoppingListSelected = "shoppingListSelected"
    case recipes = "reciepes"
    case recipesSelected = "recipesSelected"
    case profileAvatar = "Avatars"
    
    
    static var editProfilePicIcon: Image {
        Image("editProfilePic")
    }

    case addRecipeImage = "UploadImage"
    static var blurRectangle: Image{
        Image("blurRectangle")
    }
    static var addImageIcon: Image{
        Image("addImageIcon")
    }
    
    
    //Recipe Images

    static var addRecipeIcon : Image{
        Image("addRecipe")
    }
    static var deleteBin: Image{
        Image("trash")
    }
    static var menuDots: Image{
        Image("menuDots")
    }
    static var noRecipePlaceholder : Image{
        Image("noRecipesPlaceholder")
    }
    case searchIcon = "Magnifer"

    
    enum Common: String {
        case thumb
    }
    
    enum ShoppingList: String {
        case merge
        case shoppingBag
        case share
        case bin
    }
    
    enum Notification: String {
        case bell
        case no_notification
        
    }
    

}
