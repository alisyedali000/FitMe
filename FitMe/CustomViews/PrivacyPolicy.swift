//
//  PrivacyPolicy.swift
//  FitMe
//
//  Created by Ali Syed on 30/11/2023.
//
import SwiftUI

struct PrivacyPolicyLink: View {

    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("By Signing up, you're agree to our")
//                    .foregroundColor(.descriptionText)
                    .font(.sansRegular(size: 14))
                    .lineLimit(1)
                    .allowsTightening(true)
                    .foregroundColor(.gray)
                
                Text("[Terms and Conditions](https://dietplanner.ml-bench.com/Terms)")
                    .tint(.redColor)
                    .font(.sansMedium(size: 14))
                    .lineLimit(1)
                    .allowsTightening(true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("and")
//                    .foregroundColor(.descriptionText)
                    .font(.sansRegular(size: 14))
                    .lineLimit(1)
                    .allowsTightening(true)
                    .foregroundColor(.gray)
                
                Text("[Privacy Policy](https://dietplanner.ml-bench.com/Privacy)")
//                    .tint(.primaryRed)
                    .font(.sansMedium(size: 14))
                    .lineLimit(1)
                    .tint(.redColor)
                    .allowsTightening(true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct PrivacyPolicyLink_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyLink()
    }
}
