//
//  StartScene.swift
//  TestTask
//
//  Created by Oleksii Ilchavskyi on 03.02.2024.
//

import SpriteKit
import AVFoundation

class StartScene: SKScene, ObservableObject {
    private var backgroundMusicPlayer: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        // Set the size of the scene
        self.size = CGSize(width: 300, height: 500)
        // Setup background, start button, asteroids, and play background music
        setupBackground()
        setupStartButton()
        setupAsteroids()
        playBackgroundMusic()
    }
    
    func playBackgroundMusic() {
        // Play background music
        let musicURL = Bundle.main.url(forResource: "StartSceneAudio", withExtension: "mp3")
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL!)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch {
            print("Error loading background music: \(error)")
        }
    }

    
    func setupBackground() {
        // Create and set up the background node
        let backgroundTexture = SKTexture(imageNamed: "Space#2")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.size = size
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        addChild(background)
    }
    
    func setupStartButton() {
        // Create and set up the start button
        let startButton = SKLabelNode(text: "Start Game")
        startButton.name = "startButton"
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        startButton.fontSize = 30
        startButton.fontColor = SKColor.white
        addChild(startButton)
    }
    
    func setupAsteroids() {
        // Set up continuous spawning and movement of asteroids
        let asteroidTexture = SKTexture(imageNamed: "asteroid")
        
        let asteroidSpawnAction = SKAction.run {
            let asteroid = SKSpriteNode(texture: asteroidTexture)
            asteroid.size = CGSize(width: 30, height: 30)
            asteroid.position = CGPoint(x: CGFloat.random(in: 0...self.size.width), y: self.size.height)
            self.addChild(asteroid)
            
            let moveAction = SKAction.moveBy(x: CGFloat.random(in: 0...self.size.width), y: -self.size.height - asteroid.size.height, duration: TimeInterval.random(in: 1...3))
            let removeAction = SKAction.removeFromParent()
            let sequenceAction = SKAction.sequence([moveAction, removeAction])
            
            asteroid.run(sequenceAction)
        }
        
        let asteroidSpawnDelay = SKAction.wait(forDuration: 0.5)
        let spawnSequence = SKAction.sequence([asteroidSpawnAction, asteroidSpawnDelay])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        
        run(spawnForever)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle touches on the start button to transition to the GameScene
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if let startButton = childNode(withName: "startButton"), startButton.contains(location) {
            backgroundMusicPlayer.stop()
            
            let transition = SKTransition.fade(withDuration: 1.0)
            let nextScene = GameScene(size: size)
            nextScene.scaleMode = scaleMode
            view?.presentScene(nextScene, transition: transition)
        }
    }
}
