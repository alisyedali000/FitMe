//
//  TagView.swift
//  FitMe
//
//  Created by Qazi Ammar Arshad on 20/12/2023.
//

import Foundation
import SwiftUI

struct TagView: View {

    @Binding var tags: [String]?
    var action: (String) -> Void

        @State private var totalHeight
              = CGFloat.zero       // << variant for ScrollView/List
        //    = CGFloat.infinity   // << variant for VStack

        var body: some View {
            VStack {
                GeometryReader { geometry in
                    self.generateContent(in: geometry)
                }
            }
            .frame(height: totalHeight)// << variant for ScrollView/List
            // .frame(maxHeight: totalHeight) // << variant for VStack
        }

        private func generateContent(in g: GeometryProxy) -> some View {
            var width = CGFloat.zero
            var height = CGFloat.zero

            return ZStack(alignment: .topLeading) {
                ForEach(self.tags!, id: \.self) { tag in
                    TagButton(title: tag, action: {
//                        action(tag)
                    })
                        .padding([.horizontal, .vertical], 3)
                        .alignmentGuide(.leading, computeValue: { d in
                            if abs(width - d.width) > g.size.width {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if tag == self.tags?.last! {
                                width = 0 // last item
                            } else {
                                width -= d.width
                            }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: {_ in
                            let result = height
                            if tag == self.tags?.last! {
                                height = 0 // last item
                            }
                            return result
                        })
                }
            }.background(viewHeightReader($totalHeight))
        }

        private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
            return GeometryReader { geometry -> Color in
                let rect = geometry.frame(in: .local)
                DispatchQueue.main.async {
                    binding.wrappedValue = rect.size.height
                }
                return .clear
            }
        }

}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(tags: .constant(["Travel", "Cricket", "Games", "Photography"]), action: { _ in })
    }
}
