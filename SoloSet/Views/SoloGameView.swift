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
                    CardView(card:card)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        
        let model = SoloGameModel()
        
        SoloGameView()
            .environmentObject(model)
            .previewInterfaceOrientation(.portrait)
    }
}
