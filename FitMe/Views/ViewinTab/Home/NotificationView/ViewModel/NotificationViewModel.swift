//
//  NotificationViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 04/01/2024.
//

import Foundation
import SwiftData
import Darwin


extension NotificationView {
    
    @Observable
    class ViewModel {
        var modelContext: ModelContext
        var notifications = [NotificationModel]()
//        Error variable for showing error message
        var showError = false
        var errorMessage = ""

        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }
        
        
        func fetchData() {
            notifications = []
            do {
                let descriptor = FetchDescriptor<NotificationModel>(sortBy: [SortDescriptor(\.createdAt)])
                notifications = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
        }
        
    }
    
}
