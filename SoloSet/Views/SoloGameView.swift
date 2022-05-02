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
            VStack {
                Text("Cards Left: \(game.cardsLeft)")
                AspectVGrid(items: game.cards, aspectRatio: 2/3) { card in
                    CardView(card:card)
                        .onTapGesture {
                            withAnimation {
                                game.choose(card)
                            }
                        }
                }
                
                HStack {
                    Spacer()
                    Button {
                        game.startNewGame()
                    } label: {
                        Label("New Game", systemImage: "gobackward")
                            .labelStyle(.titleAndIcon)
                    }
                    Spacer()
                    Button {
                        withAnimation { game.dealMoreCards() }
                    } label: {
                        Label("Deal Cards", systemImage: "plus.square.on.square")
                            .labelStyle(.titleAndIcon)
                    }
                    .disabled(game.cardsLeft > 3 ? false : true)
                    Spacer()
                }
                
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let model = SoloGameModel()
        
        SoloGameView()
            .environmentObject(model)
            .previewInterfaceOrientation(.portrait)
    }
}
