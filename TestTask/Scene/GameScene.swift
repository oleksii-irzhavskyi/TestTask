//
//  GameScene.swift
//  TestTask
//
//  Created by Oleksii Ilchavskyi on 03.02.2024.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, ObservableObject {
    // Published properties to observe changes
    @Published var score = 0
    @Published var isGameStarted = false
    @Published var isGameOver = false
    private var obstacleSpeed: CGFloat = 3.0
    private var scoreLabel: SKLabelNode!
    private var backgroundMusicPlayer: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        // Set the size of the scene
        self.size = CGSize(width: 300, height: 500)
        // Setup background, score label, player, and background music
        setupBackground()
        setupScoreLabel()
        setupPlayer()
        enablePlayerMovement()
        playBackgroundMusic(nameAudio: "GameSceneAudio", numberOfLoops: -1)
        
        // Start spawning asteroids with a delay
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addAsteroid),
                SKAction.wait(forDuration: 1.0)
            ])
        ))
        
        // Set up physics world
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
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
    
    func setupPlayer() {
        // Create and set up the player node
        let playerTexture = SKTexture(imageNamed: "Spaceship#1")
        let player = SKSpriteNode(texture: playerTexture)
        player.name = "player"
        
        let playerSize = CGSize(width: 25, height: 25)
        player.size = playerSize
        
        player.position = CGPoint(x: size.width / 2, y: 100)
        addChild(player)
        
        // Set up physics body for collision detection
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = 2
    }
    
    func setupScoreLabel() {
        // Create and set up the score label
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 50)
        scoreLabel.fontColor = SKColor.white
        addChild(scoreLabel)
        updateScoreLabel()
    }
    
    func updateScoreLabel() {
        // Update the displayed score
        scoreLabel.text = "Score: \(score)"
    }
    
    func playBackgroundMusic(nameAudio: String, numberOfLoops: Int) {
        // Play background music
        let musicURL = Bundle.main.url(forResource: nameAudio, withExtension: "mp3")
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL!)
            backgroundMusicPlayer.numberOfLoops = numberOfLoops // -1 вказує на безкінечне відтворення
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch {
            print("Error loading background music: \(error)")
        }
    }
    
    func removeAllObjects() {
        // Remove all nodes from the scene
        children.forEach { $0.removeFromParent() }
    }
    
    func enablePlayerMovement() {
        // Set up swipe gestures for player movement
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRight.direction = .right
        view?.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeft.direction = .left
        view?.addGestureRecognizer(swipeLeft)
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        // Handle swipe gestures for player movement
        guard let player = childNode(withName: "player") as? SKSpriteNode else { return }
        
        switch sender.direction {
        case .right:
            if player.position.x <= size.width - player.size.width / 2 {
                let moveAction = SKAction.moveBy(x: 50, y: 0, duration: 0.3)
                player.run(moveAction)
            }
        case .left:
            if player.position.x >= player.size.width / 2 {
                let moveAction = SKAction.moveBy(x: -50, y: 0, duration: 0.3)
                player.run(moveAction)
            }
        default:
            break
        }
    }
    
    func addAsteroid() {
        // Ensure the game is not over before adding a new asteroid
        guard !isGameOver else { return }
        
        // Create a new asteroid
        let asteroid = createAsteroid()
        // Add the asteroid to the scene
        addChild(asteroid)
        
        // Set up physics properties for collision detection
        setupPhysics(for: asteroid)
        
        // Define actions for asteroid movement and removal
        let moveAction = moveAsteroid(asteroid)
        let removeAction = removeAsteroid()
        
        // Run the sequence of actions, and execute the completion block
        asteroid.run(SKAction.sequence([moveAction, removeAction])) {
            // Handle completion of asteroid animation
            self.handleAsteroidCompletion()
        }
    }
    
    func createAsteroid() -> SKSpriteNode {
        // Load texture for the asteroid
        let asteroidTexture = SKTexture(imageNamed: "asteroid")
        // Create a sprite node with the asteroid texture
        let asteroid = SKSpriteNode(texture: asteroidTexture)
        // Set a unique name for identification
        asteroid.name = "asteroid"
        
        // Define size and position for the asteroid
        let asteroidSize = CGSize(width: 50, height: 50)
        asteroid.size = asteroidSize
        let randomX = CGFloat.random(in: 0...(size.width - asteroidSize.width))
        asteroid.position = CGPoint(x: randomX + asteroidSize.width / 2, y: size.height)
        
        return asteroid
    }
    
    func setupPhysics(for asteroid: SKSpriteNode) {
        // Set up physics body for collision detection
        asteroid.physicsBody = SKPhysicsBody(rectangleOf: asteroid.size)
        asteroid.physicsBody?.categoryBitMask = 2
        asteroid.physicsBody?.collisionBitMask = 0
        asteroid.physicsBody?.contactTestBitMask = 1
    }
    
    func moveAsteroid(_ asteroid: SKSpriteNode) -> SKAction {
        // Define the movement action for the asteroid
        return SKAction.moveBy(x: 0, y: -size.height, duration: TimeInterval(obstacleSpeed))
    }
    
    func removeAsteroid() -> SKAction {
        // Define the action to remove the asteroid from the scene
        return SKAction.removeFromParent()
    }
    
    func handleAsteroidCompletion() {
        // Check if the game is still ongoing
        if !isGameOver {
            // Increment the score and update the score label
            score += 1
            updateScoreLabel()
            
            // Increase obstacle speed every 10 points, but not below 2.0
            if score % 10 == 0 && obstacleSpeed > 2.0 {
                obstacleSpeed -= 0.1
            }
        }
    }
    
    
    func gameOver() {
        // Handle game over state
        backgroundMusicPlayer.stop()
        playBackgroundMusic(nameAudio: "GameOverAudio", numberOfLoops: 0)
        updateScoreLabel()
        removeAllObjects()
        obstacleSpeed = 3.0
        isGameStarted = false
        isGameOver = true
        
        // Display game over label, final score, and buttons
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        gameOverLabel.fontColor = SKColor.red
        addChild(gameOverLabel)
        
        let finalScoreLabel = SKLabelNode(text: "Score: \(score)")
        finalScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        finalScoreLabel.fontColor = SKColor.white
        addChild(finalScoreLabel)
        
        let restartButton = SKLabelNode(text: "Restart")
        restartButton.name = "restartButton"
        restartButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        restartButton.fontColor = SKColor.orange
        addChild(restartButton)
        
        let menuButton = SKLabelNode(text: "Back to Menu")
        menuButton.name = "menuButton"
        menuButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        menuButton.fontColor = SKColor.orange
        addChild(menuButton)
        
        score = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Handle touches on buttons during game over state
        guard let touch = touches.first, isGameOver else { return }
        
        let location = touch.location(in: self)
        let nodesAtLocation = nodes(at: location)
        
        for node in nodesAtLocation {
            if node.name == "restartButton" {
                playBackgroundMusic(nameAudio: "GameSceneAudio", numberOfLoops: -1)
                isGameOver = false
                removeAllChildren()
                setupBackground()
                setupScoreLabel()
                setupPlayer()
                enablePlayerMovement()
                isGameStarted = true
            }else if let returnButton = childNode(withName: "menuButton"), returnButton.contains(location){
                returnToStartScene()
            }
        }
    }
    
    func returnToStartScene() {
        // Transition to the start scene
        let transition = SKTransition.fade(withDuration: 1.0)
        let startScene = StartScene(size: size)
        startScene.scaleMode = scaleMode
        view?.presentScene(startScene, transition: transition)
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        // Handle collisions between player and asteroids
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else {
            return
        }
        
        if nodeA.name == "player" && nodeB.name == "asteroid" || nodeA.name == "asteroid" && nodeB.name == "player" {
            gameOver()
        }
    }
}


