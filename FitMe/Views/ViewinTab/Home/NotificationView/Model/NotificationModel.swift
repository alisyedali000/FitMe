//
//  NotificationModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 04/01/2024.
//

import Foundation
import SwiftData

@Model
class NotificationModel {
    
    var id: UUID
    var title: String
    var message: String
    var isChecked: Bool
    var createdAt: Date
    
    init(id: UUID, title: String, message: String, isChecked: Bool, createdAt: Date) {
        self.id = id
        self.title = title
        self.message = message
        self.isChecked = isChecked
        self.createdAt = createdAt
    }
}

let mockNotifications = [
    NotificationModel(id: UUID(), title: "🥦🥕 Nourish your body, fuel your workouts!", message: "Check out our new meal plans for delicious and healthy recipes. Discover a world of flavors with FitMe!", isChecked: true, createdAt: Date()),
    NotificationModel(id: UUID(), title: "🏋️‍♂️ Ready for a Challenge?", message: "Join our fitness challenge and achieve your goals. Stay active and motivated!", isChecked: false, createdAt: Date()),
    NotificationModel(id: UUID(), title: "🍏 New Nutritional Tips!", message: "Learn about the benefits of different nutrients and how they contribute to your overall health.", isChecked: false, createdAt: Date()),
    NotificationModel(id: UUID(), title: "🎉 Exclusive Offers!", message: "Don't miss out on our special promotions. Grab exciting discounts on FitMe products today!", isChecked: false, createdAt: Date())
]

