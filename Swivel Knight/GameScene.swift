//
//  GameScene.swift
//  Swivel Knight
//
//  Created by Shepherd Mobile on 6/27/15.
//  Copyright (c) 2015 Shepherd Mobile. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit
import iAd

class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate, ADBannerViewDelegate {
    
    var bannerView: ADBannerView!
    
    // GAME VARIABLES
    var highScore:Int = 0
    var gameOver = false
    var score = 0
    var spiralAngle = 0
    var spiralAngleTwo = 0
    let numberOfSpirals = UInt32(4)     // THIS VARIABLE CONTROLS THE NUMBER OF SPIRAL PATTERNS AVAILABLE
    var arrowSpeed = 0.35               // THIS VARIABLE CONTROLS HOW FAST THE ARROWS SPAWN
    var arrowTravelSpeed = 1.25         // THIS VARIABLE CONTROLS HOW FAST THE ARROWS MOVE
    var fullCycle = 9.8                 // ((self.arrowSpeed * 21) + (self.arrowSpeed / 5) * 35) || 21 wait and 35 quickWait
    var barSize = CGFloat(0)
    
    // SPRITE NODES & LABELS
    let progressBar = SKSpriteNode()
    var gameOverFrame = SKSpriteNode()
    var replayGameButton = SKSpriteNode()
    var shareButton = SKSpriteNode()
    var menuButton = SKSpriteNode()
    var gameOverLabel = SKSpriteNode()
    var scoreLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
    let hero = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "knightColor")!)
    let shield = SKSpriteNode(imageNamed: UserDefaults.standard.string(forKey: "shieldColor")!)
    let mute = UserDefaults.standard.bool(forKey: "mute")
    let highScoreLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
    let barFiller = SKSpriteNode(imageNamed: "BarFiller.png")
    let tapToStartLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
    let startGate = SKSpriteNode(imageNamed: "ClearFrame.png")
    
    // SOUND FILES
    let blockSound = SKAction.playSoundFileNamed("Block.wav", waitForCompletion: false)
    let collectSound = SKAction.playSoundFileNamed("Collect.wav", waitForCompletion: false)
    
    // PHYSICS GROUPS
    let heroGroup:UInt32 = 1
    let shieldGroup:UInt32 = 2
    let arrowGroup:UInt32 = 3
    
    // DID MOVE TO VIEW
    override func didMove(to view: SKView) {
        if !mute {
            GameViewController.playBackgroundMusic("GameTheme.mp3")
        }
        self.setupGame()
        self.setupBannerAd()
        
    }
    
    // BANNER AD FUNCTIONS
    func setupBannerAd() {
        bannerView = ADBannerView(adType: .banner)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.delegate = self
        bannerView.isHidden = true
        view!.addSubview(bannerView)
    }
    
    func bannerViewDidLoadAd(_ banner: ADBannerView!) {
        bannerView.isHidden = false
    }
    
    func bannerView(_ banner: ADBannerView!, didFailToReceiveAdWithError error: Error!) {
        bannerView.isHidden = true
    }

    
    // GAME CENTER FUNCTIONS
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func saveHighScore(_ identifier:String, score:Int) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            let scoreReporter = GKScore(leaderboardIdentifier: identifier)
            scoreReporter.value = Int64(score)
            let scoreArray:[GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: {
                error -> Void in
                if error != nil {
                    print("error")
                } else {
                    print("posted score of \(score)")
                }
            })
        }
    }
    
    // GAME FUNCTIONS
    func randomPointOnCircle(_ radius:Float, center:CGPoint) -> CGPoint {
        let theta = Float(arc4random_uniform(UInt32.max))/Float(UInt32.max) * Float(M_PI) * 2.0
        let x = radius * cosf(theta)
        let y = radius * sinf(theta)
        return CGPoint(x: CGFloat(x) + center.x, y: CGFloat(y) + center.y)
    }
    
    func specificPointOnCircle(_ radius:Float, center:CGPoint, angle:Float) -> CGPoint {
        let theta = angle * Float(M_PI)/180
        let x = radius * cosf(theta)
        let y = radius * sinf(theta)
        return CGPoint(x: CGFloat(x) + center.x, y: CGFloat(y) + center.y)
    }
    
    func createArrow(_ position: CGPoint) -> SKSpriteNode {
        let arrow = SKSpriteNode(imageNamed: "Arrow.png")
        arrow.name = "Arrow"
        arrow.zPosition = 2
        arrow.size = CGSize(width: self.frame.size.width * 0.12, height: self.frame.size.width * 0.025)
        arrow.physicsBody = SKPhysicsBody(rectangleOf: arrow.frame.size)
        arrow.physicsBody?.isDynamic = true
        arrow.physicsBody?.categoryBitMask = arrowGroup
        arrow.physicsBody?.usesPreciseCollisionDetection = true
        arrow.physicsBody?.contactTestBitMask = heroGroup | shieldGroup
        arrow.position = position
        
        let heroPosition = hero.position
        let angle = atan2(heroPosition.y - position.y, heroPosition.x - position.x)
        let rotateAction = SKAction.rotate(toAngle: angle, duration: 0.0)
        arrow.run(rotateAction)
        
        return arrow
    }
    
    func createGoldenArrow(_ position: CGPoint) -> SKSpriteNode {
        let arrow = SKSpriteNode(imageNamed: "GoldenArrow.png")
        arrow.name = "GoldenArrow"
        arrow.zPosition = 2
        arrow.size = CGSize(width: self.frame.size.width * 0.12, height: self.frame.size.width * 0.025)
        arrow.physicsBody = SKPhysicsBody(rectangleOf: arrow.frame.size)
        arrow.physicsBody?.isDynamic = true
        arrow.physicsBody?.categoryBitMask = arrowGroup
        arrow.physicsBody?.usesPreciseCollisionDetection = true
        arrow.physicsBody?.contactTestBitMask = heroGroup | shieldGroup
        arrow.position = position
        
        let heroPosition = hero.position
        let angle = atan2(heroPosition.y - position.y, heroPosition.x - position.x)
        let rotateAction = SKAction.rotate(toAngle: angle, duration: 0.0)
        arrow.run(rotateAction)
        
        return arrow
    }
    
    func setupGame() {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        self.score = 0
        self.barSize = 0
        
        // BACKGROUND
        self.backgroundColor = SKColor.black
        
        let bgTexture = SKTexture(imageNamed: "GrassBG.png")
        let bg = SKSpriteNode(texture: bgTexture)
        bg.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        bg.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        bg.zPosition = 0
        self.addChild(bg)
        
        let topTrees = SKTexture(imageNamed: "TopTrees.png")
        let topBorder = SKSpriteNode(texture: topTrees)
        topBorder.size = CGSize(width: self.frame.size.width, height: self.frame.size.height * 0.15)
        topBorder.position = CGPoint(x: self.size.width / 2, y: self.size.height - (self.frame.size.height * 0.07))
        topBorder.zPosition = 20
        self.addChild(topBorder)
        
        let bottomTrees = SKTexture(imageNamed: "BottomTrees.png")
        let bottomBorder = SKSpriteNode(texture: bottomTrees)
        bottomBorder.size = CGSize(width: self.frame.size.width, height: self.frame.size.height * 0.15)
        bottomBorder.position = CGPoint(x: self.size.width / 2, y: (self.frame.size.height * 0.07))
        bottomBorder.zPosition = 20
        self.addChild(bottomBorder)
        
        // HERO, SHIELD, AND JOINT
        hero.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        hero.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        hero.zPosition = 99
        hero.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        hero.physicsBody = SKPhysicsBody(circleOfRadius: (hero.frame.size.height / 2) * 0.2)
        hero.physicsBody!.isDynamic = false
        hero.physicsBody!.usesPreciseCollisionDetection = true
        hero.physicsBody?.categoryBitMask = heroGroup
        self.addChild(hero)
        
        shield.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2 - hero.size.height * 0.55)
        shield.size = CGSize(width: self.frame.size.width * 0.1, height: self.frame.size.width * 0.02)
        shield.zPosition = 100
        shield.physicsBody = SKPhysicsBody(rectangleOf: shield.size)
        shield.physicsBody!.isDynamic = true
        shield.physicsBody?.usesPreciseCollisionDetection = true
        shield.physicsBody?.categoryBitMask = shieldGroup
        self.addChild(shield)
        
        let shieldJoint = SKPhysicsJointFixed.joint(withBodyA: hero.physicsBody!, bodyB: shield.physicsBody!, anchor: CGPoint(x: self.hero.frame.midX, y: self.shield.frame.maxY))
        self.physicsWorld.add(shieldJoint)
        
        // SCORE
        scoreLabel.text = "0"
        scoreLabel.fontSize = self.frame.size.height * 0.1
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.size.height * 0.91)
        scoreLabel.zPosition = 120
        self.addChild(scoreLabel)
        
        // PROGRESS BAR
        let progressBarTexture = SKTexture(imageNamed: "Bar.png")
        let progressBar = SKSpriteNode(texture: progressBarTexture)
        progressBar.size = CGSize(width: self.frame.size.width * 0.90, height: self.frame.size.height * 0.07)
        progressBar.zPosition = 120
        progressBar.position = CGPoint(x: self.frame.midX, y: self.frame.size.height * 0.0525)
        self.addChild(progressBar)
        
        // BAR FILLER
        barFiller.size = CGSize(width: 0, height: self.frame.size.height * 0.016)
        barFiller.anchorPoint = CGPoint(x: 0, y: 0)
        barFiller.zPosition = 130
        barFiller.position = CGPoint(x: self.frame.size.width * 0.1125, y: self.frame.size.height * 0.046)
        self.addChild(barFiller)
        
        // TAP TO START
        tapToStartLabel.text = "Tap To Start!"
        tapToStartLabel.fontSize = self.frame.size.height * 0.07
        tapToStartLabel.zPosition = 1000
        tapToStartLabel.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.65)
        let fadeSequence = SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.fadeIn(withDuration: 1)]))
        tapToStartLabel.run(fadeSequence)
        addChild(tapToStartLabel)
        
        startGate.size = CGSize(width: self.frame.width, height: self.frame.height)
        startGate.zPosition = 2000
        startGate.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5)
        startGate.name = "startGate"
        addChild(startGate)
        
        // BANNER AD
        
        
    }
    
    func startGame() {
        let game = SKAction.run{
            
            let spiralNumber = Int(arc4random_uniform(self.numberOfSpirals) + 1)
            
            let moveArrow = SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.midY), duration: self.arrowTravelSpeed)
            var list = [SKAction]()
            
            // RANDOM ARROWS
            let goldenArrowSpawn = Int(arc4random_uniform(20))
            
            for i in 0 ..< 20 {
                if i != goldenArrowSpawn {
                    let spawn = SKAction.run {
                        let randomArrow = self.createArrow(self.randomPointOnCircle(Float(self.frame.size.width), center: CGPoint(x: self.frame.midX, y: self.frame.midY)))
                        self.addChild(randomArrow)
                        randomArrow.run(moveArrow)
                    }
                    list.append(spawn)
                    let barFill = SKAction.run {
                        self.barSize+=1
                        let increaseBarFill = SKAction.resize(toWidth: self.frame.size.width * (0.0385 * self.barSize), duration: self.arrowSpeed)
                        self.barFiller.run(increaseBarFill)
                    }
                    list.append(barFill)
                    let wait = SKAction.wait(forDuration: self.arrowSpeed)
                    list.append(wait)
                } else {
                    let spawn = SKAction.run {
                        let randomArrow = self.createGoldenArrow(self.randomPointOnCircle(Float(self.frame.size.width), center: CGPoint(x: self.frame.midX, y: self.frame.midY)))
                        self.addChild(randomArrow)
                        randomArrow.run(moveArrow)
                    }
                    list.append(spawn)
                    let barFill = SKAction.run {
                        self.barSize+=1
                        let increaseBarFill = SKAction.resize(toWidth: self.frame.size.width * (0.0385 * self.barSize), duration: self.arrowSpeed)
                        self.barFiller.run(increaseBarFill)
                    }
                    list.append(barFill)
                    let wait = SKAction.wait(forDuration: self.arrowSpeed)
                    list.append(wait)
                }
            }
            
            // SPIRAL LEFT
            if spiralNumber == 1 {
                self.spiralAngle = Int(arc4random_uniform(360) + 1)
                for _ in 0 ..< 36 {
                    let create = SKAction.run {
                        let arrow = self.createArrow(self.specificPointOnCircle(Float(self.frame.size.width), center: CGPoint(x: self.frame.midX, y: self.frame.midY), angle: Float(self.spiralAngle * 10)))
                        self.spiralAngle+=1
                        self.addChild(arrow)
                        arrow.run(moveArrow)
                    }
                    list.append(create)
                    let quickWait = SKAction.wait(forDuration: self.arrowSpeed/5)
                    list.append(quickWait)
                    let barEmpty = SKAction.run {
                        self.barSize = 0
                        let decreaseBarFill = SKAction.resize(toWidth: 0, duration: 0.5)
                        self.barFiller.run(decreaseBarFill)
                    }
                    list.append(barEmpty)
                }
            }
            
            // SPIRAL RIGHT
            if spiralNumber == 2 {
                self.spiralAngle = Int(arc4random_uniform(360) + 1)
                for _ in 0 ..< 36 {
                    let create = SKAction.run {
                        let arrow = self.createArrow(self.specificPointOnCircle(Float(self.frame.size.width), center: CGPoint(x: self.frame.midX, y: self.frame.midY), angle: Float(self.spiralAngle * 10)))
                        self.spiralAngle = self.spiralAngle - 1
                        self.addChild(arrow)
                        arrow.run(moveArrow)
                    }
                    list.append(create)
                    let quickWait = SKAction.wait(forDuration: self.arrowSpeed/5)
                    list.append(quickWait)
                    let barEmpty = SKAction.run {
                        self.barSize = 0
                        let decreaseBarFill = SKAction.resize(toWidth: 0, duration: 0.5)
                        self.barFiller.run(decreaseBarFill)
                    }
                    list.append(barEmpty)
                }
            }
            
            // HALF LEFT - HALF RIGHT
            if spiralNumber == 3 {
                self.spiralAngle = Int(arc4random_uniform(360) + 1)
                for _ in 0 ..< 18 {
                    let create = SKAction.run {
                        let arrow = self.createArrow(self.specificPointOnCircle(Float(self.frame.size.width), center: CGPoint(x: self.frame.midX, y: self.frame.midY), angle: Float(self.spiralAngle * 10)))
                        self.spiralAngle+=1
                        self.addChild(arrow)
                        arrow.run(moveArrow)
                    }
                    list.append(create)
                    let quickWait = SKAction.wait(forDuration: self.arrowSpeed/5)
                    list.append(quickWait)
                }
                self.spiralAngleTwo = Int(arc4random_uniform(360) + 1)
                for _ in 0 ..< 18 {
                    let create = SKAction.run {
                        let arrow = self.createArrow(self.specificPointOnCircle(Float(self.frame.size.width), center: CGPoint(x: self.frame.midX, y: self.frame.midY), angle: Float(self.spiralAngleTwo * 10)))
                        self.spiralAngleTwo = self.spiralAngleTwo - 1
                        self.addChild(arrow)
                        arrow.run(moveArrow)
                    }
                    list.append(create)
                    let quickWait = SKAction.wait(forDuration: self.arrowSpeed/5)
                    list.append(quickWait)
                }
                let barEmpty = SKAction.run {
                    self.barSize = 0
                    let decreaseBarFill = SKAction.resize(toWidth: 0, duration: 0.5)
                    self.barFiller.run(decreaseBarFill)
                }
                list.append(barEmpty)
            }
            
            // HAL RIGHT - HALF LEFT
            if spiralNumber == 4 {
                self.spiralAngle = Int(arc4random_uniform(360) + 1)
                for _ in 0 ..< 18 {
                    let create = SKAction.run {
                        let arrow = self.createArrow(self.specificPointOnCircle(Float(self.frame.size.width), center: CGPoint(x: self.frame.midX, y: self.frame.midY), angle: Float(self.spiralAngle * 10)))
                        self.spiralAngle = self.spiralAngle - 1
                        self.addChild(arrow)
                        arrow.run(moveArrow)
                    }
                    list.append(create)
                    let quickWait = SKAction.wait(forDuration: self.arrowSpeed/5)
                    list.append(quickWait)
                }
                self.spiralAngleTwo = Int(arc4random_uniform(360) + 1)
                for _ in 0 ..< 18 {
                    let create = SKAction.run {
                        let arrow = self.createArrow(self.specificPointOnCircle(Float(self.frame.size.width), center: CGPoint(x: self.frame.midX, y: self.frame.midY), angle: Float(self.spiralAngleTwo * 10)))
                        self.spiralAngleTwo+=1
                        self.addChild(arrow)
                        arrow.run(moveArrow)
                    }
                    list.append(create)
                    let quickWait = SKAction.wait(forDuration: self.arrowSpeed/5)
                    list.append(quickWait)
                }
                let barEmpty = SKAction.run {
                    self.barSize = 0
                    let decreaseBarFill = SKAction.resize(toWidth: 0, duration: 0.5)
                    self.barFiller.run(decreaseBarFill)
                }
                list.append(barEmpty)
            }
            
            // RUN ONE CYCLE
            self.arrowTravelSpeed -= 0.05
            let sequence = SKAction.sequence(list)
            self.run(sequence)
        }
        
        // RUN GAME SEQUENCE
        let cycleWait = SKAction.wait(forDuration: fullCycle)
        let fullSequence = SKAction.sequence([game, cycleWait])
        let gameSequence = SKAction.repeatForever(fullSequence)
        self.run(gameSequence)
    }
    
    // RESET
    func reset() {
        self.removeAllChildren()
        self.gameOver = false
        let viewSize = self.view?.bounds.size
        let scene = GameScene(size: viewSize!)
        self.view?.presentScene(scene)
    }
    
    // HIGH SCORE CALCULATION
    func newScore() {
        // CHECK IF score > highScore NSUserDefaults STORED VALUE AND CHANGE NSUserDefaults STORED VALUE IF TRUE
        if self.score > UserDefaults.standard.integer(forKey: "highscore") {
            UserDefaults.standard.set(score, forKey: "highscore")
            UserDefaults.standard.synchronize()
            self.saveHighScore("SwivelKnightHighScores", score: self.score)
        }
    }
    
    // CONTACT
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if firstBody.categoryBitMask == heroGroup{
            secondBody.node?.removeFromParent()
            gameOver = true
        }
        if firstBody.categoryBitMask == shieldGroup{
            if secondBody.node?.name == "GoldenArrow" {
                if !mute {
                    self.run(collectSound)
                }
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") + 1, forKey: "goldenArrows")
                UserDefaults.standard.synchronize()
                score += 1
                scoreLabel.text = "\(score)"
                secondBody.node?.removeFromParent()
            } else {
                if !mute {
                    self.run(blockSound)
                }
                score+=1
                scoreLabel.text = "\(score)"
                secondBody.node?.removeFromParent()
            }
        }
    }
    
    // TAP
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        let touchPosition = touch!.location(in: self)
        let touchedNode = self.atPoint(touchPosition)
        let heroPosition = hero.position
        let angle = atan2(heroPosition.y - touchPosition.y, heroPosition.x - touchPosition.x)
        let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI * 1.5), duration: 0.0)
        hero.run(rotateAction)
        if touchedNode.name == "replayGame" {
            self.reset()
        }
        if touchedNode.name == "shareButton" {
            let textToShare = "I just scored \(score) on Swivel Knight! Think you can beat that? #SwivelKnight"
            let objectsToShare = [textToShare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            let vc = self.view?.window?.rootViewController
            vc!.present(activityVC, animated: true, completion: nil)
        }
        if touchedNode.name == "menuButton" {
            if !mute {
                GameViewController.playBackgroundMusic("MainTheme.mp3")
            }
            let viewSize = self.view?.bounds.size
            let scene = MainMenu(size: viewSize!)
            self.view?.presentScene(scene)
        }
        if touchedNode.name == "startGate" {
            startGame()
            startGate.removeFromParent()
            tapToStartLabel.removeFromParent()
        }
    }
    
    // SLIDE
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        let touchPosition = touch!.location(in: self)
        let heroPosition = hero.position
        let angle = atan2(heroPosition.y - touchPosition.y, heroPosition.x - touchPosition.x)
        let rotateAction = SKAction.rotate(toAngle: angle + CGFloat(M_PI * 1.5), duration: 0.0)
        hero.run(rotateAction)
    }
    
    // UPDATE
    override func update(_ currentTime: TimeInterval) {
        if gameOver == true {
            self.scene!.view?.isPaused = true
            scoreLabel.isHidden = true
            newScore()
            
            // GAME OVER FRAME
            if self.score >= 500 {
                gameOverFrame = SKSpriteNode(imageNamed: "DiamondGameOverFrame.png")
                menuButton = SKSpriteNode(imageNamed: "DiamondMenuButton.png")
                replayGameButton = SKSpriteNode(imageNamed: "DiamondRetryButton.png")
                shareButton = SKSpriteNode(imageNamed: "DiamondShareButton.png")
                gameOverLabel = SKSpriteNode(imageNamed: "DiamondGameOverLabel.png")
            } else if self.score >= 300 {
                gameOverFrame = SKSpriteNode(imageNamed: "GoldGameOverFrame.png")
                menuButton = SKSpriteNode(imageNamed: "GoldMenuButton.png")
                replayGameButton = SKSpriteNode(imageNamed: "GoldRetryButton.png")
                shareButton = SKSpriteNode(imageNamed: "GoldShareButton.png")
                gameOverLabel = SKSpriteNode(imageNamed: "GoldGameOverLabel.png")
            } else if self.score >= 200 {
                gameOverFrame = SKSpriteNode(imageNamed: "SilverGameOverFrame.png")
                menuButton = SKSpriteNode(imageNamed: "SilverMenuButton.png")
                replayGameButton = SKSpriteNode(imageNamed: "SilverRetryButton.png")
                shareButton = SKSpriteNode(imageNamed: "SilverShareButton.png")
                gameOverLabel = SKSpriteNode(imageNamed: "SilverGameOverLabel.png")
            } else if self.score >= 100 {
                gameOverFrame = SKSpriteNode(imageNamed: "BronzeGameOverFrame.png")
                menuButton = SKSpriteNode(imageNamed: "BronzeMenuButton.png")
                replayGameButton = SKSpriteNode(imageNamed: "BronzeRetryButton.png")
                shareButton = SKSpriteNode(imageNamed: "BronzeShareButton.png")
                gameOverLabel = SKSpriteNode(imageNamed: "BronzeGameOverLabel.png")
            } else {
                gameOverFrame = SKSpriteNode(imageNamed: "GameOverFrame.png")
                menuButton = SKSpriteNode(imageNamed: "MenuButton.png")
                replayGameButton = SKSpriteNode(imageNamed: "RetryButton.png")
                shareButton = SKSpriteNode(imageNamed: "ShareButton.png")
                gameOverLabel = SKSpriteNode(imageNamed: "GameOverLabel.png")
            }
            gameOverFrame.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.45)
            gameOverFrame.size = CGSize(width: self.frame.size.width * 0.75, height: self.frame.size.height * 0.35)
            gameOverFrame.zPosition = 15000
            addChild(gameOverFrame)
            
            // GAME OVER LABEL
            gameOverLabel.position = CGPoint(x: self.size.width / 2, y: (self.size.height * 0.725))
            gameOverLabel.size = CGSize(width: self.frame.size.width * 0.75, height: self.frame.size.height * 0.08)
            gameOverLabel.zPosition = 20000
            addChild(gameOverLabel)
            
            // HIGH SCHORE LABEL
            highScoreLabel.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "highscore"))
            highScoreLabel.fontSize = self.frame.size.height * 0.035
            highScoreLabel.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2 + self.frame.size.height * 0.06))
            highScoreLabel.zPosition = 20000
            addChild(highScoreLabel)
            
            // SCORE LABEL
            scoreLabel.fontSize = self.frame.size.height * 0.1
            scoreLabel.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2 - self.frame.size.height * 0.025))
            scoreLabel.zPosition = 20000
            scoreLabel.isHidden = false
            
            // REPLAY
            replayGameButton.size = CGSize(width: self.frame.size.width * 0.65, height: self.frame.size.height * 0.085)
            replayGameButton.zPosition = 20000
            replayGameButton.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2 - self.frame.size.height * 0.07))
            replayGameButton.name = "replayGame"
            addChild(replayGameButton)
            
            // SHARE
            shareButton.size = CGSize(width: self.frame.size.width * 0.65, height: self.frame.size.height * 0.085)
            shareButton.zPosition = 20000
            shareButton.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2 - self.frame.size.height * 0.125))
            shareButton.name = "shareButton"
            addChild(shareButton)
            
            // MENU
            menuButton.size = CGSize(width: self.frame.size.width * 0.65, height: self.frame.size.height * 0.085)
            menuButton.zPosition = 20000
            menuButton.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2 - self.frame.size.height * 0.18))
            menuButton.name = "menuButton"
            addChild(menuButton)
        }
    }
}
