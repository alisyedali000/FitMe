//
//  MeasurementRulers.swift
//  FitMe
//
//  Created by Ali Syed on 06/12/2023.
//

import SwiftUI
import SlidingRuler

struct WeightAndHeightRulers: View {
    @StateObject var rulerVM : RulersVM
    @State var heightScale : HeightScale = .cm
    @State var weightScale : WeightScale = .kg
    
    @Binding var heightString : String
    @Binding var weightString : String
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("Height")
                        .font(.sansBold(size: 16))
                    Spacer()
                    HStack{
                        SelectionButton(title: "CM's", image: Image(uiImage: UIImage()), isSelected: rulerVM.heightScale == .cm, isSmall: true) {
                            self.heightScale = .cm
                            rulerVM.heightScale = heightScale
                        }
                        SelectionButton(title: "Feet", image: Image(uiImage: UIImage()), isSelected: rulerVM.heightScale == .feet, isSmall: true) {
                            heightScale = .feet
                            rulerVM.heightScale = heightScale
                        }

                    }
                }
                /// The SlidingRuler can be simplified by applying a ternary operator in range, but it causes some issues when a scale is changed thats why two SlidingRuler are used for each measurement.
                
//                SlidingRuler(value: $rulerVM.height,
//                             in: rulerVM.heightScale == .feet ? 1...8 : 110...190,
//                             step: 1,
//                             snap: .fraction,
//                             tick: .fraction,
//                             formatter: rulerVM.formatter)
//                .onChange(of: rulerVM.height, perform: { value in
//                    rulerVM.adjustScales()
//                    self.heightString = String(format: "%.2f %@", rulerVM.height, rulerVM.heightScaleString)
//                    print(heightString)
//                })
                
  
                if rulerVM.heightScale == .cm{
                    SlidingRuler(value: $rulerVM.height,
                                 in: 110...190,
                                 step: 1,
                                 snap: .fraction,
                                 tick: .fraction,
                                 formatter: rulerVM.formatter)
                    .onChange(of: rulerVM.height, perform: { value in
                        rulerVM.adjustScales()
                        self.heightString = String(format: "%.2f %@", rulerVM.height, rulerVM.heightScaleString)
                        
                        print(heightString)
                        
                    })
                    
                }
                if rulerVM.heightScale == .feet{
                    SlidingRuler(value: $rulerVM.height,
                                 in: 1...8,
                                 step: 1,
                                 snap: .fraction,
                                 tick: .fraction,
                                 formatter: rulerVM.formatter)
                    .onChange(of: rulerVM.height, perform: { value in
                        rulerVM.adjustScales()
                        self.heightString = String(format: "%.2f %@", rulerVM.height, rulerVM.heightScaleString)
                        
                        print(heightString)
                        
                    })
                }


                
                HStack{
                    Text("Weight")
                        .font(.sansBold(size: 16))
                    Spacer()
                    
                    HStack{
                        SelectionButton(title: "Kg", image: Image(uiImage: UIImage()), isSelected: rulerVM.weightScale == .kg, isSmall: true) {
                            weightScale = .kg
                            rulerVM.weightScale = weightScale
                        }
                        SelectionButton(title: "Pounds", image: Image(uiImage: UIImage()), isSelected: rulerVM.weightScale == .pound, isSmall: true) {
                            weightScale = .pound
                            rulerVM.weightScale = weightScale
                        }
                    }
                }
                if rulerVM.weightScale == .kg{
                    SlidingRuler(value: $rulerVM.weight,
                                 in: 30...250,
                                 step: 1,
                                 snap: .fraction,
                                 tick: .fraction,
                                 formatter: rulerVM.formatter)
                    .onChange(of: rulerVM.weight, perform: { value in
                        rulerVM.adjustScales()
                        self.weightString = String(format: "%.2f %@", rulerVM.weight, rulerVM.weightScaleString)
                        
                        print(weightString)
                        
                    })
                }
                if rulerVM.weightScale == .pound{
                    SlidingRuler(value: $rulerVM.weight,
                                 in: 66...551,
                                 step: 1,
                                 snap: .fraction,
                                 tick: .fraction,
                                 formatter: rulerVM.formatter)
                    .onChange(of: rulerVM.weight, perform: { value in
                        rulerVM.adjustScales()
                        self.weightString = String(format: "%.2f %@", rulerVM.weight, rulerVM.weightScaleString)
                        
                        print(weightString)
                        
                    })
                }
            }
        }
    }
}

#Preview {
    WeightAndHeightRulers(rulerVM: RulersVM(), heightString: .constant(""), weightString: .constant(""))
}
