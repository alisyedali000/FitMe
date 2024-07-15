//
//  NotificationView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 04/01/2024.
//

import SwiftUI
import SwiftData


struct NotificationView: FitMeBaseView {
    
    @State private var sortOrder = SortDescriptor(\NotificationModel.createdAt,
                                                   order: .forward)
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            loadView
                .navigationTitle("Notification")
                .toolbarTitleDisplayMode(.inline)
                .toolbarRole(.editor)
            
            HStack {
                
                Button{
                    addMockNotifcation()
                }label: {
                    ImageName.addRecipeIcon
                        .resizable()
                        .frame(width: 56 , height: 56)
                }
            }
            
        }

    }
    
    
    func addMockNotifcation()  {
        let mockNotification = mockNotifications.randomElement()!
        modelContext.insert(mockNotification)
        do {
            try modelContext.save()
        } catch {
            print(error.localizedDescription)
        }
        viewModel.fetchData()
    }
}

// MAKR: UIIView Extension

extension NotificationView {
    
    var loadView: some View {
        VStack {
            
            if viewModel.notifications.isEmpty {
                noNotificationView
            } else {
                notificationList
            }
            
        }
    }
    
    
    var noNotificationView: some View {
        VStack {
            HStack{Spacer()}
            Spacer()
            Image(ImageName.Notification.no_notification.rawValue)
                .shadow(radius: 5)
            Text("No Notifications received yet!")
                .font(.sansMedium(size: 16))
            Spacer()
        }
    }
    
    var notificationList: some View {
        
        List(viewModel.notifications) { notification in
            NotificationCard(notification: notification)
                .swipeActions {
                    Button("Delete", role: .destructive) {
                        modelContext.delete(notification)
                    }
                }
        }
        
    }
    
}

#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: NotificationModel.self, configurations: config)
        
        return NotificationView(modelContext: container.mainContext)
        
    } catch {
        return Text("Failt to load context with error \(error.localizedDescription)")
    }
    
    
}
