//
//  AppLogo.swift
//  Koy
//
//  Created by Taimoor Arif on 01/09/2023.
//

import SwiftUI

struct AppLogo: View {
    
    var body: some View {
        
        HStack {
            ImageName.appLogo
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
            
            Text("FitMe")
                .foregroundStyle(Color.redColor)
                .font(.sansMedium(size: 32))
            
            Spacer()
        }
    }
}

struct AppLogo_Previews: PreviewProvider {
    static var previews: some View {
        AppLogo()
    }
}
