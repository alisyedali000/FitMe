
//
//  OTP Field.swift
//  ProBau
//
//  Created by Ali Syed on 18/09/2023.
//

import SwiftUI



import SwiftUI

struct OTP_Fields: View {
    @Binding var OTPText: String
    @FocusState private var isKeyboardShowing: Bool
    var body: some View {
       
        loadView()
    }
}
extension OTP_Fields{
    
    func loadView()->some View{
        VStack(){
            
            OTPView()
            
        }
        
        
    }
    func OTPView()->some View{
       
        HStack() {
            ForEach(0..<4, id:\.self){ index in
                OTPBoxes(index)
            }
        }
        .background(content:{
            TextField("", text: $OTPText.limits(4))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 1,height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isKeyboardShowing)
        })
        .contentShape(Rectangle())
        .onTapGesture {
            isKeyboardShowing.toggle()
        }
        
        }
        
    @ViewBuilder
    func OTPBoxes(_ index: Int)->some View{
        ZStack{
            if OTPText.count > index {
                let startIndex = OTPText.startIndex
                let charIndex = OTPText.index(startIndex,offsetBy: index)
                let charToString = String(OTPText[charIndex])
                Text(charToString)
            }else{
                Text(" ")
            }
         
                     
                   
            if isKeyboardShowing && OTPText.count == index {
                Text("|")
                    .foregroundColor(.redColor)
                    .modifier(BlinkingCursor())
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.redColor, lineWidth: 1)
                           .frame(width:55,height: 55)
                        
                           .padding(10)
                 
            }

        }
        
        .frame(width:50,height: 50)
        .background{
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.textfieldBackground,lineWidth: 9)
                .background(Color.textfieldBackground)
        }.padding(.horizontal,10).padding(.vertical)
        
    }
        
    }
extension View{
    func disablewithOpacity(_ condition: Bool)-> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6:1)
    }
}

extension Binding where Value == String{
    func limits(_ length:Int)->Self{
        DispatchQueue.main.async {
            self.wrappedValue = String(self.wrappedValue.prefix(length))
        }
        return self
    }
}
        
    struct OTP_Field_Previews: PreviewProvider {
        static var previews: some View {
            OTP_Fields(OTPText: .constant("1234"))
        }
    }

struct BlinkingCursor: ViewModifier {
    @State private var isBlinking = false

    func body(content: Content) -> some View {
        content
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    self.isBlinking.toggle()
                }
            }
            .opacity(isBlinking ? 0 : 1)
    }
}
