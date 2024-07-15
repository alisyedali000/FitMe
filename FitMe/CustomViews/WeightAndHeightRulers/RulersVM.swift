//
//  RulersVM.swift
//  FitMe
//
//  Created by Ali Syed on 06/12/2023.
//

import Foundation
class RulersVM : ObservableObject{
    @Published var height = 0.0
    @Published var weight = 0.0

    @Published var weightScaleString = ""
    @Published var heightScaleString = ""
    @Published var heightScale : HeightScale = .cm
    @Published var weightScale : WeightScale = .kg
    
    var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 1
        return f
    }
    
    func adjustScales(){
        switch weightScale {
        case .kg:
            weightScaleString = "KG"
        case .pound:
            weightScaleString = "Pound"
        }
        
        switch heightScale {
        case .cm:
            heightScaleString = "CM"
        case .feet:
            heightScaleString = "Feet"
        }
        
    }

    func extractValAndSetScale(from string: String) -> Double{
            let components = string.components(separatedBy: " ")
            
            if components.count >= 2, let value = Double(components[0]) {
                // Extract value and set weight or height
                switch components[1] {
                case "KG":
                    weight = value
                    weightScale = .kg
                    return value
                case "Pound":
                    weight = value
                    weightScale = .pound
                    return value
                case "CM":
                    height = value
                    heightScale = .cm
                    return value
                case "Feet":
                    height = value
                    heightScale = .feet
                    return value
                default:
                    break
                }
            }
        return 0.0
        }
}
