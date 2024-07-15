//
//  CustomMoifiers.swift
//  Koy
//
//  Created by Taimoor Arif on 01/09/2023.
//

import Foundation
import SwiftUI

extension View {
    
//    var addGreenBorder: some View {
//        modifier(AddGreenBorder())
//    }
    
//    var addWhiteBorder: some View {
//        modifier(AddWhiteBorder())
//    }
    
//    var addRectangleGreenBorder: some View {
//        modifier(RectangleGreenBorder())
//    }
    
//    var addBlackBorder: some View {
//        modifier(AddBlackBorder())
//    }
    
    var addDoneButton: some View {
        modifier(DoneButton())
    }
    
    var hideNavigationBar: some View {
        modifier(HideNavBar())
    }
}

//struct AddGreenBorder : ViewModifier {
//
//    func body(content: Content) -> some View {
//        content
//            .overlay {
//                Circle()
//                    .stroke(Color.appGreenColor, lineWidth: 1)
//            }
//    }
//}
//
//struct AddWhiteBorder : ViewModifier {
//
//    func body(content: Content) -> some View {
//        content
//            .overlay {
//                Circle()
//                    .stroke(.white, lineWidth: 2)
//            }
//    }
//}
//
//struct RectangleGreenBorder : ViewModifier {
// 
//    func body(content: Content) -> some View {
//        content
//            .overlay {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.appGreenColor, lineWidth: 1)
//            }
//    }
//}
//
//struct AddBlackBorder : ViewModifier {
//
//    func body(content: Content) -> some View {
//        content
//            .overlay {
//                Circle()
//                    .stroke(Color.black, lineWidth: 2)
//            }
//    }
//}

struct HideNavBar : ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

struct DoneButton: ViewModifier {
       
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        UIApplication.shared.removeResponder()
                    }
                    .foregroundStyle(.blue)
                    .padding(.trailing, 20)
                }
            }
    }
}

extension UIApplication {
    
    func removeResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension String {
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespacesAndNewlines) == "")
    }
    
    var addPercentageEncoding: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
    var isValueEmpty: Bool {
        
        if self.isEmpty || self.isEmptyOrWhitespace() {
            return true
        }
        
        return false
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension View {
    func onBackSwipe(perform action: @escaping () -> Void) -> some View {
        gesture(
            DragGesture()
                .onEnded({ value in
                    if value.startLocation.x < 50 && value.translation.width > 80 {
                        action()
                    }
                })
        )
    }
}

extension Text {
    func concatenate(components: [String]) -> Text {
        var resultText = Text("")
        for (index, component) in components.enumerated() {
            if index % 2 == 0 {
                resultText = resultText + Text(component)
            } else {
                resultText = resultText + Text(component).bold()
            }
        }
        return resultText
    }
}

func formatTextWithBold(_ text: String) -> Text {
    let components = text.components(separatedBy: "**")
    return Text("").concatenate(components: components)
}
