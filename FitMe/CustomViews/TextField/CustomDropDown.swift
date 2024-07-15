//
//  CustomDropDown.swift
//  FitMe
//
//  Created by Ali Syed on 07/12/2023.
//

import SwiftUI

struct CustomDropDown<T: Identifiable & Hashable & DropdownDisplayable>: View {
    var placeholder: String
    var menuOptions: [T]
    @Binding var selectedIndex: Int?
    @State var selectedItemName: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack {
                Menu {
                    ForEach(menuOptions, id: \.self) { value in
                        Button {
                            selectedItemName = ""
                            selectedIndex = value.index
                        } label: {
                            Text(value.displayName)
                            
                            
                            
                        }
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color.textfieldBackground)
                            .frame(height: 50)
                        HStack {
                            
                            if selectedItemName.isEmpty {
                                Text((selectedIndex == nil ? placeholder : "\(menuOptions.first { $0.index == selectedIndex }?.displayName ?? "")"))
                                    .font(.sansRegular(size: 14))
                                    .foregroundColor(selectedIndex == nil ? .gray : .black)
                            } else {
                                Text(selectedItemName)
                                    .font(.sansRegular(size: 14))
                                    .foregroundColor(selectedIndex == nil ? .gray : .black)
                            }
                            
                            
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .frame(width: 30,height: 30)
                        }.padding()
                    }
                }
            }
        }
    }
}


struct StringDropDown: View {
    var placeholder : String
    var menuOptions : [String]
    @Binding var selectedOption : String
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: 10){

            VStack {
                
                Menu {
                    ForEach(menuOptions, id: \.self) { value in
                        Button{
                            selectedOption = value
                            print(value)
                        }label:{
                            Text(value)
                        }
                    }
                } label: {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color.textfieldBackground)
                            .frame(height: 50)
                        HStack{
                            Text((selectedOption == "" ? placeholder : selectedOption))
                                .font(.sansRegular(size: 14))
                                .foregroundColor(.gray)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                                .frame(width: 30,height: 30)
                            
                        }.padding()
                        
                    }
                }
                
                
            }
            
            
        }
        
    }
}


#Preview {
    
    @State var selectedCategoryIndex: Int?
    
    return CustomDropDown(placeholder: "Select Category", menuOptions: [
            FoodCategories(id: 1, name: "Vegetarian", select: true),
            FoodCategories(id: 2, name: "Vegan", select: false),
            FoodCategories(id: 3, name: "Non-Vegetarian", select: true)
        ], selectedIndex: $selectedCategoryIndex)
}
