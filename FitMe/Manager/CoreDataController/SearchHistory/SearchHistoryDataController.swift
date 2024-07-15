//
//  RecentSearchController.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 19/12/2023.
//


import CoreData
import Foundation

class SearchHistoryDataController {
    private var persistentContainer = NSPersistentContainer(name: "SearchHistory")

    init() {
        setupPersistentContainer()
    }

    private func setupPersistentContainer() {
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                debugPrint("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }

    func fetchRecentSearches() throws -> [SearchItem] {
        let fetchRequest: NSFetchRequest<SearchItem> = SearchItem.fetchRequest()
        fetchRequest.sortDescriptors = []

        return try persistentContainer.viewContext.fetch(fetchRequest)
    }

    func addSearchTerm(_ name: String) {
        let newItem = SearchItem(context: persistentContainer.viewContext)
        newItem.name = name
        saveContext()
    }

    func removeSearchItem(_ item: SearchItem) {
        persistentContainer.viewContext.delete(item)
        saveContext()
    }

    private func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
