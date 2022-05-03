//
//  StripeView.swift
//  SoloSet
//
//  Created by Brent on 2/5/2022.
//

import SwiftUI

struct StripeView: View {
    
    private struct Constants {
        static let minStripeHeight:CGFloat = 2
    }
    
    var stripeHeightDivisor = CGFloat(4)
    
    var body: some View {
        GeometryReader { geo in
            
            let stripeHeight:CGFloat = max(geo.size.height / stripeHeightDivisor, Constants.minStripeHeight)
            let rows = Int((geo.size.height / stripeHeight).rounded(.up))
            
            VStack (spacing: 0) {
                ForEach(0...rows, id: \.self) { row in
                    Rectangle()
                        .frame(width: geo.size.width, height: stripeHeight / 2)
                    Rectangle()
                        .frame(width: geo.size.width, height: stripeHeight / 2)
                        .opacity(0)
                }
                
            }
            
        }
    }
}

struct StripeView_Previews: PreviewProvider {
    static var previews: some View {
        StripeView()
            .foregroundColor(.orange)
    }
}
