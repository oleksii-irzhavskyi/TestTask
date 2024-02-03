//
//  SpriteKitView.swift
//  TestTask
//
//  Created by Oleksii Ilchavskyi on 03.02.2024.
//

import SwiftUI
import SpriteKit

struct SpriteKitView: UIViewRepresentable {
    // Represents a SpriteKit scene to be displayed
    var scene: SKScene

    // Creates and returns the initial UIView
    func makeUIView(context: Context) -> SKView {
        // Create a SpriteKit view
        let skView = SKView()
        // Present the provided scene in the view
        skView.presentScene(scene)
        // Return the configured SpriteKit view
        return skView
    }

    // Updates the UIView when needed (no updates in this case)
    func updateUIView(_ uiView: SKView, context: Context) {}
}

