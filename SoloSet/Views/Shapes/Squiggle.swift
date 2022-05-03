//
//  Squiggle.swift
//  SoloSet
//
//  Created by Brent on 3/5/2022.
//

import SwiftUI

struct Squiggle: Shape {
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let centre = CGPoint(x: rect.midX, y: rect.midY)
        let offsetAmount = CGSize(width: rect.width / 4, height: rect.width / 1.5)
        
        // far west point
        let farWestPoint = CGPoint(x: centre.x - 2 * offsetAmount.width, y: centre.y)
        // north west
        let northWestPoint = CGPoint(x: centre.x - offsetAmount.width, y: centre.y - offsetAmount.height)
        // centre point
        // north eat point
        let northEastPoint = CGPoint(x: centre.x + offsetAmount.width, y: centre.y - offsetAmount.height)
        // far east point
        let farEastPoint = CGPoint(x: centre.x + 2*offsetAmount.width, y: centre.y)
        // east point
        let eastPoint = CGPoint(x: centre.x + offsetAmount.width, y: centre.y)
        // south point
        let southPoint = CGPoint(x: centre.x, y: centre.y + offsetAmount.height)
        // west point
        let westPoint = CGPoint(x: centre.x - offsetAmount.width, y: centre.y)
        // far west point
        
        p.move(to: farWestPoint)
        
        func drawUsingArcs() {
            // Arcs Version
            addArcForPath(&p, betweenOrigin: farWestPoint, andTarget: centre)
            addArcForPath(&p, betweenOrigin: centre, andTarget: farEastPoint)
            addArcForPath(&p, betweenOrigin: farEastPoint, andTarget: eastPoint, invertAngles: true)
            addArcForPath(&p, betweenOrigin: eastPoint, andTarget: westPoint, invertAngles: true)
            addArcForPath(&p, betweenOrigin: westPoint, andTarget: farWestPoint, invertAngles: true)
        }
        
        func drawUsingCurves() {
            // Curves Version
            p.addQuadCurve(to: centre, control: northWestPoint)
            p.addQuadCurve(to: farEastPoint, control: northEastPoint)
            p.addQuadCurve(to: eastPoint, control: CGPoint(x: farEastPoint.x,
                                                           y: midPointBetween(farEastPoint, andTarget: eastPoint).y + offsetAmount.height / 2))
            p.addQuadCurve(to: westPoint, control: southPoint)
            p.addQuadCurve(to: farWestPoint, control: CGPoint(x: farWestPoint.x,
                                                           y: midPointBetween(westPoint, andTarget: farWestPoint).y + offsetAmount.height / 2))
        }
        
        drawUsingCurves()
        
        
        return p
    }
    
    private func addArcForPath(_ p: inout Path, betweenOrigin origin:CGPoint, andTarget target:CGPoint, invertAngles:Bool = false, clockwise:Bool = true) {
        p.addArc(center: midPointBetween(origin, andTarget: target),
                 radius: distanceBetween(origin, andTarget: target) / 2,
                 startAngle: Angle(degrees: invertAngles ? 180 : 0),
                 endAngle: Angle(degrees: invertAngles ? 0 : 180),
                 clockwise: clockwise ? true : false)
    }
    
    private func addCurveForPath(_ p: inout Path, midPoint:CGPoint, target:CGPoint) {
        
        p.addQuadCurve(to: target, control: midPoint)
        
    }
    
    private func midPointBetween(_ origin:CGPoint, andTarget target:CGPoint) -> CGPoint {
        
        let mx = abs(origin.x + target.x) / 2
        let my = abs(origin.y + target.y) / 2
        
        return CGPoint(x: mx, y: my)
        
    }
    
    private func distanceBetween(_ origin:CGPoint, andTarget target:CGPoint) -> CGFloat {
        
        let aSquared = pow(target.x - origin.x, 2.0)
        let bSquared = pow(target.y - origin.y, 2.0)

        return CGFloat(sqrt(aSquared + bSquared))
        
    }
    
}

struct Squiggle_Previews: PreviewProvider {
    static var previews: some View {
        Squiggle()
            .stroke()
    }
}
