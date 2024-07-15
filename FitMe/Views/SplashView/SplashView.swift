//
//  SplashView.swift
//  FitMe
//
//  Created by Taimoor Arif on 20/11/2023.
//

import SwiftUI

struct SplashView: View {
    
    private struct Config {
        
        static let title = "Let’s make your personalized FitMe Meal Planner"
        static let description = "Get on track, stay on track. Select your personal diet requirements, food preferences and nutrition goals for a unique customised meal plan!"
        
        static let buttonTitle = "Get Started"
    }
    
    var body: some View {
        
        loadView()
            .ignoresSafeArea()
    }
}

extension SplashView {
    
    func loadView() -> some View {
        
        VStack(spacing: 20) {
            
            let size = UIScreen.main.bounds
            
            ImageName.splashImage
                .resizable()
                .scaledToFill()
                .frame(width: size.width, height: size.height * 0.5)
            
            Spacer()
            
            VStack(spacing: 20) {
                
                Text(Config.title)
                    .foregroundStyle(.black)
                    .font(.sansMedium(size: 26))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
             
                Text(Config.description)
                    .foregroundStyle(.gray)
                    .font(.sansRegular(size: 14))
                    .multilineTextAlignment(.center)
                
                Button {
                    
                    UserDefaultManager.shared.setSplashShownStatus()
                        
                    
                } label: {
                    
                    RedButtonView(title: Config.buttonTitle)
                        .padding(.bottom)
                }

            }
            .padding()
        }
    }
}

#Preview {
    SplashView()
}
