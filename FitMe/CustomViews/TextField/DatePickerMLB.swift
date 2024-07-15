//
//  DatePicker.swift
//  ProBau
//
//  Created by Ali Syed on 06/10/2023.
//

import Foundation
import SwiftUI

struct DatePickerMLB: View {
    @State private var date = Date()
    @Binding var showDatePicker: Bool
    var displayedComponents: DatePickerComponents = [.date]
    var action: (Date) -> Void
    
    
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                DatePicker("", selection: $date, in: ...Date(), displayedComponents: displayedComponents)
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .background(
                        Color.white
   
                    )
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .tint(.redColor)
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .frame(height: 45)
                        .foregroundColor(.white)
                        .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                    
                    HStack {
                        Button {
                            self.action(date)
                            showDatePicker = false
                        } label: {
                            Text("OK")
                                .foregroundColor(.redColor)
                
                        }.background()
                            .padding()
                        Button {
                            showDatePicker = false
                        } label: {
                            Text("Cancel")
                                .foregroundColor(.grayImages)
                
                        }.background()
                            .padding()
                    }
            
                }
  
            }.padding()

        }
    }
}

struct DatePickerMLB_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerMLB (showDatePicker: .constant(false)) { data  in
            print(data)
        }
    }
}
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape( RoundedCorner(radius: radius, corners: corners) )
//    }
//}
//struct RoundedCorner: Shape {
//
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}

func addOrSubtractYear(year:Int) -> Date {
  return Calendar.current.date(byAdding: .year, value: year, to: Date())!
}
