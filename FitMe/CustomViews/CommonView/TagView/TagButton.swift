//
//  TagButton.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 20/12/2023.
//

import Foundation

import SwiftUI

struct TagButton: View {


    var title = ""
    var action: () -> Void

    var body: some View {

        
        HStack {
            Text(title)
                .lineLimit(1)
                .padding([.leading, .trailing], 15)
                .padding([.top, .bottom], 7)

        }
        .foregroundColor(.textGray)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .foregroundStyle(Color.textfieldBackground)
        )
    }
}

struct SkillButton_Previews: PreviewProvider {
    static var previews: some View {
        TagButton(title: "Travling") {
            
        }
    }
}
