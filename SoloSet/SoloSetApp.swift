//
//  SoloSetApp.swift
//  SoloSet
//
//  Created by Brent on 13/4/2022.
//

import SwiftUI

@main
struct SoloSetApp: App {
    
    private var game:SoloGameModel = SoloGameModel()
    
    var body: some Scene {
        WindowGroup {
            SoloGameView()
                .environmentObject(game)
        }
    }
}
