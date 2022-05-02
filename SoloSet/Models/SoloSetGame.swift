//
//  SoloSetGame.swift
//  SoloSet
//
//  Created by Brent on 19/4/2022.
//

import Foundation

struct SoloSetGame {
    
    private struct Constants {
        static let idealNumberOfCardsToDisplay = 12
        static let newCardsToAdd = 3
    }
    
    enum FeatureState:Int, CaseIterable {
        case one = 1, two, three
        
        static var variations:ClosedRange<Int> { 1...FeatureState.allCases.count }
    }
    
    enum Feature:CaseIterable { case shape, colour, shading, number }
    
    private(set) var cards:[Card]
    private var allowedNumberOfCards = Constants.idealNumberOfCardsToDisplay
    
    private var selectedCards:[Card] { self.cards.filter { $0.isSelected == true} }
    
    // filter the first 15 cards in the deck that aren't matched.
    // if 15 cards are not available
    public var deltCards:[SoloSetGame.Card] {
        // filter the unmatched cards as they are the valid ones to be displayed or is selected
        let possibleCardsToDisplay = cards.filter { !$0.isMatched || $0.isSelected }
        return possibleCardsToDisplay.prefix(allowedNumberOfCards).map{ $0 }
    }
    
    public var cardsLeft:Int {
        
        let matchedCards = cards.filter { $0.isMatched }
        
        return cards.count - matchedCards.count - deltCards.count
        
    }
    
    init(){
        self.cards = SoloSetGame.generateCards()
        shuffleDeck()
    }
    
    mutating public func reset() {
        self.cards = SoloSetGame.generateCards()
        shuffleDeck()
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
    
    mutating func addMoreCards() {
        
        // replaces the selected cards if they make a set
        guard !isSet() else {
            deselectAllSelectedCards()
            //            setSelectedCardsToMatched()
            
            return
        }
        
        // if no set, add 3 more cards to the screen and maintain selection
        allowedNumberOfCards += Constants.newCardsToAdd
    }
    
    mutating func selectCard(id:Int) {
        
        // check to see if we have a set
        
        // deselect all selected cards if count is 3 regardless of match
        if selectedCards.count == 3 {
            if isSet(),
               allowedNumberOfCards > Constants.idealNumberOfCardsToDisplay  {
                allowedNumberOfCards -= Constants.newCardsToAdd
            }

            deselectAllSelectedCards()            
        }
        
        // TODO: Maybe put in a check here to only set if not matched.
        if let index = self.cards.firstIndex(where: { $0.id == id }) {
            self.cards[index].isSelected = true
        }
        
        if isSet() { setSelectedCardsToMatched() }
    }
    
    mutating private func setSelectedCardsToMatched() {
        
        // if we have a set, set all the selected cards to is matched.
        selectedCards.forEach({ selectedCard in
            if let index = self.cards.firstIndex(where: { selectedCard.id == $0.id }) {
                self.cards[index].isMatched = true
            }
        })
    }
    
    mutating private func deselectAllSelectedCards() {
        selectedCards.forEach { selectedCard in
            if let index = self.cards.firstIndex(where: { card in
                selectedCard.id == card.id
            }) {
                self.cards[index].isSelected = false
            }
        }
    }
    
    mutating func deselectCard(id:Int) {
        
        // only deselect if cards if selected cards is less than 3
        guard selectedCards.count < 3 else { return }
        
        if let index = self.cards.firstIndex(where: { $0.id == id }) {
            self.cards[index].isSelected = false
        }
    }
    
    /// Returns true if all the features of the selected cards are either the same OR all different
    func isSet() -> Bool {
        
        guard selectedCards.count == 3 else { return false }
        
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
        var isMatched = false
        
    }
}
