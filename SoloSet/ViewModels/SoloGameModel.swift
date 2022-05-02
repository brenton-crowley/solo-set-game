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
    
    public func startNewGame() {
        objectWillChange.send()
        soloSet.reset()
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
        
        let shapeView = shapeViewForShapeFeature(shape)
        
        switch shading {
        case .one:
            shapeView.stroke()
        case .two:
            shapeView
        case .three:
//            shapeView.opacity(shadedOpacity)
            StripeView()
                .clipShape(shapeView)
                .background(
                    shapeView.stroke()
                )
        }
    }
    
    private func shapeViewForShapeFeature(_ shape:FeatureState) -> some Shape {
        switch shape {
        case .one:
            return AnyShape(Circle())
        case .two:
            return AnyShape(Diamond())
        case .three:
            return AnyShape(Rectangle())
        }
    }
    
}

// copy the shape and cast it as an AnyShape
struct AnyShape: Shape {
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return _path(rect)
    }

    private let _path: (CGRect) -> Path
}
