//
//  ContentView.swift
//  FitMe
//
//  Created by Taimoor Arif on 20/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State var isAuthenticated = UserDefaultManager.IsAuthenticated()
    @AppStorage ("splash") var isSplashShown = UserDefaultManager.shared.isSplashShown()
    var body: some View {
        Group{
            if isAuthenticated{
                TabBarView()
            }else{
                if isSplashShown{
                    LoginView()
                }else{
                    SplashView()
                }
            }

        } .onReceive(UserDefaultManager.Authenticated) { newValue in
            user_id = "\(UserDefaultManager.shared.get()?.id ?? 0)"
            isAuthenticated = newValue
        }.onAppear(){
            if !isAuthenticated{
                UserDefaultManager.shared.setSocialLogin(false) //If user try to log in with social account but does not completes its profile details
            }
        }


        


    }
}

#Preview {
    ContentView()
}
