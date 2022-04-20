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
    
    /// Returns true if all the features of the selected cards are either the same OR all different
    func isSet() -> Bool {
        
        // Create an array of sets based on the features of the selected cards.
        let featureSets = [
            setForFeature(\.shading),
            setForFeature(\.colour),
            setForFeature(\.shape),
            setForFeature(\.number),
        ]
        
        // If a set's length is either 1 or 3, then we have a match.
        // This must be true for all sets. If any set has a count of 2, then false.
        return featureSets.allSatisfy { $0.count == 1 || $0.count == 3 }
    }
    
    /// Return a set for the feature (shape, number, shading, colour) within the selectedCards.
    /// If the length of the set is 1, then the feature is the same across all the selected cards. -> Valid
    /// If the length of the set is 3, then the feature is different across all the selected cards. -> Valid
    /// If the length of the set is 2, then the feature is neither all the same nor all different -> Invalid
    private func setForFeature(_ feature:KeyPath<Card, FeatureState>) -> Set<FeatureState> {
        
        var matches = Set<FeatureState>()
        
        // Gets the featureState for each selected card and adds them to the set.
        // Since sets must have unique values, no two values will be added twice.
        selectedCards.forEach { matches.insert($0[keyPath: feature])}

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
