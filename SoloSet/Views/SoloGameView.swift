//
//  SoloGameView.swift
//  SoloSet
//
//  Created by Brent on 13/4/2022.
//

import SwiftUI

struct SoloGameView: View {
    
    private struct Constants {
        static let cardCornerRadius:CGFloat = 20.0
    }
    
    @EnvironmentObject private var game:SoloGameModel
    
    var body: some View {
        NavigationView {
            VStack {
                AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                    cardViewForCard(card)
                        .onTapGesture {
                            withAnimation {
                                game.choose(card)
                            }
                        }
                }
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Deal Cards") {
                        withAnimation {
                            game.dealMoreCards()
                        }
                    }.disabled(game.cardsLeft > 3 ? true : false)
                }
            }
        }
    }
    
    @ViewBuilder
    private func cardViewForCard(_ card:SoloSetGame.Card) -> some View {
        ZStack {
            
            let cardColour:Color = card.isSelected ? .orange : .black
            
            RoundedRectangle(cornerRadius: 8.0)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 8.0)
                .stroke()
                .foregroundColor(cardColour)
                .padding(2)
            
            let numElements:ClosedRange<Int> = 1...game.intForNumberFeatureState(card.number)
            let content = game.contentForShape(card.shape, andShading: card.shading)
            
            VStack {
                ForEach(numElements, id: \.self) { i in
                    content
                        .foregroundColor(game.colourForColourFeatureState(card.colour))
                }
            }
            .padding(.horizontal, 30) // TODO: will need to make this a relative value
            .padding(.vertical) // TODO: will need to make this a relative value
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SoloGameView()
            .environmentObject(SoloGameModel())
            .previewInterfaceOrientation(.portrait)
    }
}
