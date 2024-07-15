//
//  GreenButtonView.swift
//  Koy
//
//  Created by Taimoor Arif on 25/09/2023.
//

import SwiftUI

struct RedButtonView: View {
    
    private var title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(Color.redColor)
                .frame(height: 56)
            
            Text(title)
                .foregroundColor(.white)
                .font(.sansMedium(size: 18))
        }
    }
}

struct RedButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RedButtonView(title: "Log in")
    }
}
