//
//  CardView.swift
//  SoloSet
//
//  Created by Brent on 29/4/2022.
//

import SwiftUI

struct CardView: View {
    
    private struct Constants {
        
        static let cornerRadius:CGFloat = 8.0
        
        // Card border colour
        static let defaultColour:Color = .gray
        static let selectedColour:Color = .blue
        
        // Card Border Width
        static let defaultLineWidth:CGFloat = 1
        static let selectedLineWidth:CGFloat = 3
    }
    
    @EnvironmentObject private var game:SoloGameModel
    
    let card:SoloSetGame.Card
    
    var body: some View {
        
        GeometryReader { geo in
            let cardPadding = geo.size.height * 0.01
            ZStack {
                
                let cardColour = card.isSelected ? Constants.selectedColour : Constants.defaultColour
                let lineWidth = card.isSelected ? Constants.selectedLineWidth : Constants.defaultLineWidth
                
                
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(lineWidth: lineWidth)
                    .foregroundColor(cardColour)
                
                let numElements:ClosedRange<Int> = 1...card.number.makeInt()
                let content = game.contentForShape(card.shape, andShading: card.shading)
                
                VStack {
                    let height = geo.size.height / 5
                    let width = geo.size.width / 3
                    ForEach(numElements, id: \.self) { i in
                        
                        // want to limit the frame of the content
                        content
                            .frame(width:width, height:height)
                            .foregroundColor(game.colourForColourFeatureState(card.colour))
                    }
                }
            }
            .padding(cardPadding)
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
//        let shape = SoloSetGame.FeatureState(rawValue: 1)!
//        let number = SoloSetGame.FeatureState(rawValue: 1)!
//        let shading = SoloSetGame.FeatureState(rawValue: 1)!
//        let colour = SoloSetGame.FeatureState(rawValue: 1)!
//
//        let card = SoloSetGame.Card(id: 0,
//                                    shape: shape,
//                                    colour: colour,
//                                    shading: shading,
//                                    number: number)
        let soloSet = SoloSetGame()
        let card  = soloSet.cards[42]
    
        CardView(card: card)
            .environmentObject(SoloGameModel())
            .previewInterfaceOrientation(.portrait)
    }
}
