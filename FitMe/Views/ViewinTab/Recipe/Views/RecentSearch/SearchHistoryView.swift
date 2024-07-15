//
//  RecentSearchView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 19/12/2023.
//

import SwiftUI

struct SearchHistoryView: View {

    @StateObject private var viewModel = SearchHistoryViewModel()
    
    
    var body: some View {
        loadView
    }
}


// MARK: - view extension
extension SearchHistoryView {
    var loadView: some View {
        VStack(alignment: .leading) {
            Text("Recent Searches")
                .font(.sansMedium(size: 20))
            recentSearches

        }

    }
    
    var recentSearches: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.recentSearches, id: \.self) { searchItem in
                    SearchHistoryCell(name: searchItem.name ?? "N/A") {
                        debugPrint(searchItem.name ?? "N/A")
                    } removeAction: {
                        viewModel.removeSearchItem(at: viewModel.recentSearches.firstIndex(of: searchItem)!)
                    }

                }
            }
        }
    }
}


#Preview {
    SearchHistoryView()
}
