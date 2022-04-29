//
//  Diamond.swift
//  SoloSet
//
//  Created by Brent on 29/4/2022.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let offsetAmount = CGSize(width: rect.width / 2, height: rect.height / 2)
        
        var p = Path()
        
        // start in the centre
        
        // move up to the start.y - height / 4, same x
        let topPoint = CGPoint(x: centre.x, y: centre.y - offsetAmount.height)
        // move to start.y, start.x - width / 4
        let leftPoint = CGPoint(x: centre.x - offsetAmount.width, y: centre.y)
        // move to start.x start.y + height / 4
        let bottomPoint = CGPoint(x: centre.x, y: centre.y + offsetAmount.height)
        // move to start.y, start.x + width / 4
        let rightPoint = CGPoint(x: centre.x + offsetAmount.width, y: centre.y)
        
        p.move(to: topPoint)
        p.addLines([topPoint, leftPoint, bottomPoint, rightPoint, topPoint])
        
        
        return p
    }
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        Diamond()
    }
}
