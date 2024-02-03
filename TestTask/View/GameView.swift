//
//  GameView.swift
//  TestTask
//
//  Created by Oleksii Ilchavskyi on 03.02.2024.
//

import SwiftUI
import SpriteKit

// SwiftUI View for the GameView
struct GameView: View {
    // State object representing the GameScene
    @StateObject private var gameScene = GameScene()
    // State object representing the StartScene
    @StateObject private var startScene = StartScene()
    // State variable to track whether the game has started
    @State private var isStartGame = false

    var body: some View {
        // VStack to conditionally display either GameScene or StartScene based on isStartGame
        VStack {
            if isStartGame {
                // Display SpriteKitView with the GameScene when isStartGame is true
                SpriteKitView(scene: gameScene)
                    .ignoresSafeArea()
                    .onDisappear {
                        // Reset isStartGame to false when leaving the GameScene
                        isStartGame = false
                    }
            } else {
                // Display SpriteKitView with the StartScene when isStartGame is false
                SpriteKitView(scene: startScene)
                    .ignoresSafeArea()
            }
        }
    }
}
