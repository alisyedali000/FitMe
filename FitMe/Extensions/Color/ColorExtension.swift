//
//  ColorExtension.swift
//  Koy
//
//  Created by Taimoor Arif on 01/09/2023.
//

import Foundation
import SwiftUI

extension Color {
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

/// Colors used in app
extension Color {
    
    static var redColor: Color {
        
        Color(hex: "#FA4A0C")
    }
    

    static var textfieldBackground: Color {
        
        Color(hex: "#F5F7FB")
    }
    
    static var grayImages: Color {
        
        Color(hex: "#ABB4C8")
    }
    static var TabBarBGColor: Color {
        
        Color(hex: "#F9F9F9")
    }
    static var profileHeaderBG : Color{
        Color(hex: "#F5F7FB")
    }
    static var profileHeaderAttributes : Color{
        Color(hex: "#ABB4C8")
    }
    static var blurEffect : Color{
        Color(hex: "#1D274133")
    }
    
    //
    //ChartColors
    static var proteinColor : Color{
        Color(hex: "#FE6F98")
    }
    static var carbsColor : Color{
        Color(hex: "#3BBAFB")
    }
    static var fatsColor : Color{
        Color(hex: "#F3C24E")
    }
 
}
