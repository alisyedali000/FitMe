//
//  AppDelegate.swift
//  FitMe
//
//  Created by Ali Syed on 04/12/2023.
//

import Foundation
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
//    GMSPlacesClient.provideAPIKey("AIzaSyCwu7xCTFEh5zblGtNh9phy_Rld65_4If8")
    return true
  }
}
