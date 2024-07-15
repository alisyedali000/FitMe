//
//  ShoppingListView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 22/12/2023.
//

import SwiftUI
import SwiftData


struct ShoppingListView: FitMeBaseView {
    
    
    let sortOptions = ["Ascending", "Descending"]
    
    @State private var selectedSortOption = "Ascending"
    @State private var isAddItemSheetOpen = false
    @State private var sortOrder = SortDescriptor(\ShoppingItem.name,
                                                   order: .forward)
    @State private var isSharePresented = false
    @State private var isMergeAlertPresented = false
    
    @Environment(\.modelContext) var modelContext
    
    @State private var viewModel: ViewModel
    
    init(modelContext: ModelContext) {
        let viewModel = ViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        
        loadView
            .padding()
            .sheet(isPresented: $isAddItemSheetOpen, content: {
                AddShoppingItemSheet()
                    .presentationDetents([.medium])
            })
            .alert("FitMe", isPresented: $viewModel.showError){
                Button("OK"){
                    
                }
            } message: {
                Text(viewModel.errorMessage)
            }
        
            .alert(isPresented: $isMergeAlertPresented) {
                Alert(
                    title: Text("Merge Confirmation"),
                    message: Text("Are you sure you want to merge the matching items? This action cannot be reverted."),
                    primaryButton: .default(Text("Proceed"), action: {
                        // Call the merge function here
                        withAnimation {
                            viewModel.mergeMatchingItems()
                        }
                    }),
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $isSharePresented) {
                ActivityViewController(activityItems: viewModel.getAllShoppingItemNames())
            }
        
    }
}

// MAKR: View extension
extension ShoppingListView {
    
    
    var loadView: some View {
        ZStack (alignment: .bottomTrailing) {
            VStack {
                navBar
                sortMergeView
                //                we make this subview just to handle sorting run time
                ShoppingListSubView(sort: sortOrder)
                
            }
            
            flootingButton
        }
    }
    
    
    var navBar: some View {
        HStack {
            
            Spacer()
            
            Text("Shopping List")
                .font(.sansMedium(size: 20))
                .offset(x: 40)
            
            Spacer()
            
            Button(action: {
                if viewModel.isListEmpty() {
                    viewModel.showError(message: "Please add items to shopping list")
                } else {
                    isSharePresented.toggle()
                }
            }, label: {
                Image(ImageName.ShoppingList.share.rawValue)
            }).padding(.leading)
            
            Button {
                if viewModel.isItemSelected() {
                    viewModel.deleteShoppingItem()
                } else {
                    viewModel.showError(message: "Please selected items to delete")
                }
            } label: {
                Image(ImageName.ShoppingList.bin.rawValue)
            }.padding(.leading)
            
        }
    }
    
    
    var sortMergeView: some View {
        
        HStack {
            sortMenu
            
            Spacer()
            
            Button(action: {
                
                if viewModel.hasMatchingItems() {
                    isMergeAlertPresented.toggle()
                } else {
                    viewModel.showError(message: "No matched item found")
                }
                
                
                
            }, label: {
                HStack {
                    Image(ImageName.ShoppingList.merge.rawValue)
                    Text("Merge")
                        .font(.sansRegular(size: 14))
                }
            })
        }
        
    }
    
    var sortMenu: some View {
        Menu {
            ForEach(sortOptions, id: \.self) { value in
                Button{
                    withAnimation {
                        selectedSortOption = value
                        if selectedSortOption == "Ascending" {
                            sortOrder = SortDescriptor(\ShoppingItem.name, order: .forward)
                        } else {
                            sortOrder = SortDescriptor(\ShoppingItem.name, order: .reverse)
                        }
                    }
                    
                }label:{
                    Text(value)
                }
            }
        } label: {
            ZStack() {
                HStack{
                    Text("\(selectedSortOption) Sort")
                        .font(.sansRegular(size: 14))
                    Image(systemName: "chevron.down")
                        .frame(width: 30,height: 30)
                    
                }.foregroundStyle(.black)
                    .padding()
                
            }
        }
    }
    
    //    MARK: Flooting Button
    
    var flootingButton: some View {
        Button {
            isAddItemSheetOpen.toggle()
        } label: {
            Image(systemName: "plus")
                .foregroundStyle(.white)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(primaryColor)
        )
        
    }
    
}


#Preview {
    
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: ShoppingItem.self, configurations: config)
        
        return ShoppingListView(modelContext: container.mainContext)
        
    } catch {
        return Text("Failt to load context with error \(error.localizedDescription)")
    }
    
    
}
