//
//  Fonts.swift
//  FitMe
//
//  Created by Taimoor Arif on 20/11/2023.
//

import Foundation
import SwiftUI

extension Font {
    
    static func sansBold(size: CGFloat) -> Font {
        self.custom("TripSans-Bold", size: size)
    }
    
    static func sansMedium(size: CGFloat) -> Font {
        self.custom("TripSans-Medium", size: size)
    }
    
    static func sansRegular(size: CGFloat) -> Font {
        self.custom("TripSans-Regular", size: size)
    }
}
