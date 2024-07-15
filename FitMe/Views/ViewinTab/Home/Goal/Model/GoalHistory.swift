//
//  GoalHistory.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 28/12/2023.
//

import Foundation

// MARK: - GoalHistory

struct GoalHistory: Codable, Equatable {
    let monday, tuesday, wednesday, thursday: Int
    let friday, saturday, sunday: Int

    enum CodingKeys: String, CodingKey {
        case monday = "Monday"
        case tuesday = "Tuesday"
        case wednesday = "Wednesday"
        case thursday = "Thursday"
        case friday = "Friday"
        case saturday = "Saturday"
        case sunday = "Sunday"
    }
}
