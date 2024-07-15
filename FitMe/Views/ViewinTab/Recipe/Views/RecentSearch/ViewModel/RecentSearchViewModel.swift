//
//  RecentSearchViewModel.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 19/12/2023.
//

import Foundation

class SearchHistoryViewModel: ObservableObject {
    private var searchController = SearchHistoryDataController()

    @Published var recentSearches: [SearchItem] = []

    init() {
        fetchRecentSearches()
    }

    func fetchRecentSearches() {
        do {
            recentSearches = try searchController.fetchRecentSearches()
        } catch {
            print("Error fetching recent searches: \(error.localizedDescription)")
        }
    }

    func addSearchTerm(_ term: String) {
        searchController.addSearchTerm(term)
        fetchRecentSearches()
    }

    func removeSearchItem(at index: Int) {
        let itemToRemove = recentSearches[index]
        searchController.removeSearchItem(itemToRemove)
        fetchRecentSearches()
    }
}
