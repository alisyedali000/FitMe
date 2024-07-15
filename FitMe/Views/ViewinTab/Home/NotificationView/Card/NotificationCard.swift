//
//  NotificationCard.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 04/01/2024.
//

import SwiftUI
import SwiftData

struct NotificationCard: FitMeBaseView {
    
    var notification: NotificationModel
    
    var body: some View {
        loadView
    }
}

extension NotificationCard {

    var loadView: some View {
        
        HStack (spacing: 10){
            Image("bell")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(primaryColor.opacity(0.3))
                )
            
            VStack(alignment: .leading) {
                HStack {
                    Text(notification.title)
                        .lineLimit(1)
                        .font(.sansMedium(size: 16))
                    Text(DateManager.shared.timeAgo(from: notification.createdAt))
                        .font(.sansRegular(size: 10))
                        .foregroundStyle(.gray)
                }
                
                Text(notification.message)
                    .font(.sansRegular(size: 12))
                    .foregroundStyle(.gray)
            }
            
        }
        
    }
    
}


#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: NotificationModel.self, configurations: config)
        let example = mockNotifications.first!
        
        return NotificationCard(notification: example)
            .padding()
            .modelContainer(container)
            
    } catch {
        return Text("Failt to load context with error \(error.localizedDescription)")
    }
    
    
}
