//
//  FitMeView.swift
//  FitMe
//
//  Created by Ali Syed on 30/11/2023.
//

import Foundation
import SwiftUI

protocol Configurable {
    
    var primaryColor: Color { get }
    var textGray: Color {get}
    var textFieldColor: Color { get }
    var grayColor: Color { get }
//    var backgroundColor: Color { get }
//    var imagePlaceHolder: Color { get }
//    var deleteColor: Color { get }
    var description : Font { get }
    var descriptionSmall : Font { get }
}

extension Configurable {
    
    var primaryColor: Color { .redColor }
    var textGray: Color {.textGray}
    var textFieldColor: Color { .textfieldBackground }
    var grayColor: Color { .grayImages }
    
    var description: Font {.sansRegular(size: 16)}
    var descriptionSmall: Font {.sansRegular(size: 12)}
}



typealias FitMeBaseView = View & Configurable

extension Text: Configurable {
    func description() -> some View {
        self.font(description)
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
    }
}
