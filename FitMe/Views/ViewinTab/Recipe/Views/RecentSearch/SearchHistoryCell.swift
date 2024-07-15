//
//  RecentSearchCell.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 19/12/2023.
//

import SwiftUI

struct SearchHistoryCell: FitMeBaseView {
    
    var name: String
    var nameTap: () ->(Void)
    var removeAction: () ->(Void)
    var body: some View {
        loadView
    }
}

// MAKR: - View extension
extension SearchHistoryCell {
    
    var loadView: some View {
        HStack {
            Button(action: {
                nameTap()
            }, label: {
                Text(name)
                    .font(.sansRegular(size: 15))
            })

            Spacer()
            
            Button(action: {
                removeAction()
            }, label: {
                Image(systemName: "multiply")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
            })
                .padding()
            
        }.foregroundStyle(.textGray)
    }
    
}


#Preview {
    SearchHistoryCell(name: "Italian Chicken Ball") {
        debugPrint("name")
    } removeAction: {
        debugPrint("cross did pressed")
    }

}
