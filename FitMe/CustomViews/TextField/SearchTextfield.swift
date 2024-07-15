//
//  SearchTextfield.swift
//  Koy
//
//  Created by Taimoor Arif on 03/10/2023.
//

import SwiftUI

struct SearchTextfield: View {
    
    @Binding private var text: String
    
    init(text: Binding<String>) {
        self._text = text
    }
    
    var body: some View {
        
        loadView()
    }
}

extension SearchTextfield {
    
    func loadView() -> some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 30)
//                .foregroundStyle(Color.searchTextfieldBackground)
                .frame(height: 36)
            
            HStack {
                
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
//                    .foregroundStyle(Color.searchTextColor)
                
                TextField("", text: $text)
                    .placeholder(when: text.isEmpty, placeholder: {
                        Text("Search")
//                            .foregroundStyle(Color.searchTextColor)
                    })
//                    .font(.sansRegular(size: 17))
                    .foregroundStyle(.white)
                    .frame(height: 32)
                    .padding(.leading, 5)
            }
            .padding()
        }
    }
}

#Preview {
    SearchTextfield(text: .constant(""))
}
