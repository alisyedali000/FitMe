//
//  FitMeApp.swift
//  FitMe
//
//  Created by Taimoor Arif on 20/11/2023.
//

import SwiftUI
import Firebase
import SwiftData

@main

struct FitMeApp: App {
    @StateObject var googleAuth = GoogleAuth()
    @StateObject var authVM = AuthViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    
    var body: some Scene {
        
        WindowGroup {
            
            NavigationStack {
                ContentView()
            }
            .environmentObject(authVM)
            .environmentObject(GoogleAuth(authVM: self.authVM))
            .environmentObject(AppleSignIn(authVM: self.authVM))
            
        }.modelContainer(for: [ShoppingItem.self, NotificationModel.self])
        
    }
}
