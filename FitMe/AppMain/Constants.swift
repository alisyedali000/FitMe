//
//  Constants.swift
//  FitMe
//
//  Created by Ali Syed on 01/12/2023.
//

import Foundation
enum WeightScale{
    case kg
    case pound
}
enum HeightScale{
    case feet
    case cm
}

enum MeasurementUnit: String {
    case grams = "grams"
    case teaspoon = "tsp"
    case tablespoon = "tbsp"
    case cups = "cups"
    case mls = "mls"
    case quantity = "quantity"
}

enum Portion: String{
    case oneHalf = "1/2"
    case oneThird = "1/3"
    case oneFourth = "1/4"
    case threeFourth = "3/4"
    case twoThird = "2/3"
    case none = ""
}


var user_id = "\(UserDefaultManager.shared.get()?.id ?? 0)"

let TODAY = "Today"
let WEEKLY = "Weekly"

let BREAKFAST = "Breakfast"
let LUNCH = "Lunch"
let DINNER = "Dinner"
let SNACKS = "Snacks"


let WEEKDAYS = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
