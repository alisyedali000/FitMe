//
//  SearchBar.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 19/12/2023.
//

import Foundation
import SwiftUI


struct SearchBar: FitMeBaseView {
    
    @Binding var text: String
    @State private var isEditing = false
    var onCancel: () -> Void
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.black.opacity(0.30))
                .opacity(0.20)
                .frame(height: 50)
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding([.leading])
                
                TextField("Search ...", text: $text)
                    .padding([.trailing,. top, .bottom],7)
                                
                                .foregroundColor(.black)
                                .font(.sansRegular(size: 14))
                                .opacity(isEditing ? 1 : 0.7)
                                .onTapGesture {
                                    self.isEditing = true
                                }
                                .focused($isSearchFocused)
                 
                            if isEditing {
                                Button(action: {
                                    self.isEditing = false
                                    self.isSearchFocused.toggle()
                                    self.text = ""
                                    onCancel()
                                }) {
                                    Text("Cancel")
                                        .foregroundColor(primaryColor)
                                }
                                .padding(.trailing, 10)
                                .transition(.move(edge: .trailing))
                                
                            }
            }
        }
        
        
        
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("Search Recipe ..."), onCancel: {
            print("on Cancel called")
        })
    }
}
