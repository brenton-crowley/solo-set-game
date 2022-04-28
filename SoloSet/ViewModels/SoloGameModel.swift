//
//  SoloGameModel.swift
//  SoloSet
//
//  Created by Brent on 28/4/2022.
//

import Foundation
import SwiftUI

class SoloGameModel:ObservableObject {
    
    typealias Card = SoloSetGame.Card
    typealias FeatureState = SoloSetGame.FeatureState
    
    private var soloSet:SoloSetGame
    
    var cards:[Card] { soloSet.deltCards }
    var cardsLeft:Int { soloSet.cardsLeft }
    
    init() {
        
        soloSet = SoloSetGame()
        
    }
    
    // MARK: - User Intents
    public func choose(_ card:Card) {
        objectWillChange.send()
        
        if card.isSelected {
            soloSet.deselectCard(id: card.id)
        } else {
            soloSet.selectCard(id: card.id)
        }
        
    }
    
    public func dealMoreCards() {
        objectWillChange.send()
        soloSet.addMoreCards()
    }
    
    // MARK: - SoloGameView Card data Pulls
    public func colourForColourFeatureState(_ featureState:FeatureState) -> Color {
        
        switch featureState {
        case .one:
            return .red
        case .two:
            return .green
        case .three:
            return .purple
        }
        
    }
    
    public func intForNumberFeatureState(_ featureState:FeatureState) -> Int {
        
        switch featureState {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        }
        
    }
    
    @ViewBuilder
    public func contentForShape(_ shape:FeatureState, andShading shading:FeatureState) -> some View {
        
        
        
        let shadedOpacity = 0.5

        switch shape {
            // circle
        case .one:
            let circle = Circle()

            switch shading {
            case .one: // empty
                circle
                    .stroke()
            case .two: // solid
                circle
            case .three: // lowered opacity
                circle
                    .opacity(shadedOpacity)
            }

        case .two:

            let oval = RoundedRectangle(cornerRadius: 10, style: .continuous)

            switch shading {
            case .one:
                oval.stroke()
            case .two:
                oval
            case .three:
                oval.opacity(shadedOpacity)
            }

        case .three:
            let rect = Rectangle()

            switch shading {
            case .one:
                rect.stroke()
            case .two:
                rect
            case .three:
                rect.opacity(shadedOpacity)
            }
        }
        
    }
    
}
