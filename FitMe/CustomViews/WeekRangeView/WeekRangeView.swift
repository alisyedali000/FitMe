//
//  WeekRangeView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 29/12/2023.
//

import SwiftUI

struct WeekDateRangeView: View {
    
    @State private var currentWeekStartDate = DateManager.shared.getLastMonday()
    @Binding var startDate: String
    @Binding var endDate: String
    
    
    
    var body: some View {
        HStack {
            Button {
                self.currentWeekStartDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentWeekStartDate)!
                updateBindingValues()
            } label: {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
            }
            
            Spacer()
            
            VStack {
                Text(getFormattedDateRange().year)
                    .font(.sansRegular(size: 20))
                Text(getFormattedDateRange().dateRange)
                    .font(.sansRegular(size: 12))
                    .foregroundStyle(.gray)
            }
            
            
            Spacer()
            
            Button(action: {
                self.currentWeekStartDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentWeekStartDate)!
                updateBindingValues()
            }, label: {
                Image(systemName: "chevron.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
            })
            
        }
        .padding()
    }
    
    
    private func getFormattedDateRange() -> (dateRange: String, year: String) {
        
        
        let endDateCalander = Calendar.current.date(byAdding: .day, value: 6, to: currentWeekStartDate)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        
        //        Start Date
        let startDateString = dateFormatter.string(from: currentWeekStartDate)
        let formattedstartDate = String(startDateString.split(separator: ",").first ?? "")
        //        End Date
        let endDateString = dateFormatter.string(from: endDateCalander)
        let formattedEndDate = String(endDateString.split(separator: ",").first ?? "")
        //        Year calculation
        let yearString = dateFormatter.string(from: currentWeekStartDate).split(separator: ",").last
        let formattedYear = String(yearString ?? "")
        
        let dateRange = "\(formattedstartDate) - \(formattedEndDate)"
        
        return (dateRange, formattedYear)
        
        
    }
    
    func updateBindingValues() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"

        let endDateCalander = Calendar.current.date(byAdding: .day, value: 6, to: currentWeekStartDate)!
        startDate = dateFormatter.string(from: currentWeekStartDate)
        endDate = dateFormatter.string(from: endDateCalander)
        
    }
    
    
}

struct WeekDateRangeView_Previews: PreviewProvider {
    static var previews: some View {
        WeekDateRangeView(startDate: .constant(""), endDate: .constant(""))
    }
}
