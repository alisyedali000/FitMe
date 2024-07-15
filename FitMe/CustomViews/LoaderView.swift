//
//  LoaderView.swift
//  FitMe
//
//  Created by Ali Syed on 04/12/2023.
//

import SwiftUI

struct LoaderView: View {
    @Binding var isLoading : Bool
    
    var body: some View {
        VStack {
            
            if isLoading {
                
                ZStack {
                    
                    Color.black.opacity(0.35)
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1)
                        .tint(.white)
                      
                    
                }
            }
        }
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(isLoading: .constant(true))
    }
}


