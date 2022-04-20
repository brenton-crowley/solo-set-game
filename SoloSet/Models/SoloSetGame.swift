//
//  SoloSetGame.swift
//  SoloSet
//
//  Created by Brent on 19/4/2022.
//

import Foundation

struct SoloSetGame {
    
    enum FeatureState:Int, CaseIterable {
        case one = 1, two, three
        
        static var variations:ClosedRange<Int> { 1...FeatureState.allCases.count }
        
    }
    
    enum Feature:CaseIterable { case shape, colour, shading, number }
    
    private var cards:[Card]
    
    var selectedCards:[Card] { self.cards.filter { $0.isSelected == true} }
    
    init(){
        self.cards = SoloSetGame.generateCards()
//        shuffleDeck()
        print(cards)
    }
    
    static func generateCards() -> [Card] {
        let variations = FeatureState.variations
        var cards = [Card]()
        for shape in variations {
            for colour in variations {
                for shading in variations {
                    for number in variations {
                        cards.append(Card(id: cards.count,
                                          shape: FeatureState(rawValue: shape)!,
                                          colour: FeatureState(rawValue: colour)!,
                                          shading: FeatureState(rawValue: shading)!,
                                          number: FeatureState(rawValue: number)!))
                    }
                }
            }
        }
        return cards
    }
    
    mutating private func shuffleDeck() {
        self.cards.shuffle()
    }
    
    mutating func selectCard(id:Int) {
        
        // only select a card if available
        
        // validate set
        
        self.cards[id].isSelected = true
    }
    
    func isSet() -> Bool {
        
        
        
        let shadingCount = setForFeature(\.shading).count
        guard shadingCount == 1 || shadingCount == 3  else { return false }
        
        let colourCount = setForFeature(\.colour).count
        guard colourCount == 1 || colourCount == 3  else { return false }
        
        let shapeCount = setForFeature(\.shape).count
        guard shapeCount  == 1 || shapeCount == 3  else { return false }
        
        let numberCount = setForFeature(\.number).count
        guard numberCount  == 1 || numberCount == 3  else { return false }
        
        return true
    }
    
    private func setForFeature(_ feature:KeyPath<Card, FeatureState>) -> Set<FeatureState> {
        
        var matches = Set<FeatureState>()
        
        switch feature {
            
        case \.shape:
            
            selectedCards.forEach { matches.insert($0.shape) }
            
        case \.colour:
            
            selectedCards.forEach { matches.insert($0.colour) }
            
        case \.number:
            
            selectedCards.forEach { matches.insert($0.number) }
            
        case \.shading:
            selectedCards.forEach { matches.insert($0.shading) }
        default:
            break
        }
        
        return matches
        
    }
    
    struct Card:Identifiable {
        
        let id:Int
        let shape:FeatureState
        let colour:FeatureState
        let shading:FeatureState
        let number:FeatureState
        
        var isSelected = false
        
    }
}
