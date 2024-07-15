//
//  BlurRectangle.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 20/12/2023.
//

import SwiftUI

struct BlurRectangle: View {
    
    var opcity: Double = 0.2
    var color: Color = .white
    
    var body: some View {
        
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(color)
                .opacity(opcity)
                
   
    }
}

#Preview {
    BlurRectangle()
}
