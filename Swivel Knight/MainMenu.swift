//
//  MainMenu.swift
//  Swivel Knight
//
//  Created by Shepherd Mobile on 8/1/15.
//  Copyright (c) 2015 Shepherd Mobile. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameKit

class MainMenu: SKScene, GKGameCenterControllerDelegate {
    
    // VARIABLES
    let title = SKSpriteNode(imageNamed: "SwivelKnightTitle.png")
    let highScoreLabel = SKLabelNode(fontNamed: "edo")
    let leaderboardButton = SKLabelNode(fontNamed: "edo")
    let muteButton = SKLabelNode(fontNamed: "edo")
    let unmuteButton = SKLabelNode(fontNamed: "edo")
    let mute = UserDefaults.standard.bool(forKey: "mute")
    var score = UserDefaults.standard.integer(forKey: "highscore")
    
    // DID MOVE TO VIEW
    override func didMove(to view: SKView) {
        
        self.authenticateLocalPlayer()
        
        self.setUpScene()
        
        if UserDefaults.standard.string(forKey: "knightColor") == nil {
            UserDefaults.standard.setValue("Knight.png", forKey: "knightColor")
            UserDefaults.standard.synchronize()
        }
        if UserDefaults.standard.string(forKey: "shieldColor") == nil {
            UserDefaults.standard.setValue("Shield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
    }
    
    // GAME CENTER
    func authenticateLocalPlayer() {
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (viewController, error ) -> Void in
            if (viewController != nil ) {
                let vc:UIViewController = self.view!.window!.rootViewController!
                vc.present(viewController!, animated: true, completion: nil)
            } else {
                print("Authentication is \(GKLocalPlayer.localPlayer().isAuthenticated)")
            }
        }
    }
    
    // SCENE SET UP
    func setUpScene() {
        // BUTTONS
        let startGameButton = SKSpriteNode(imageNamed: "PlayRed.png")
        startGameButton.size = CGSize(width: self.frame.size.width * 0.55, height: self.frame.size.height * 0.0675)
        startGameButton.zPosition = 1000
        startGameButton.position = CGPoint(x: self.frame.midX, y: self.frame.size.height * 0.65)
        startGameButton.name = "startGame"
        addChild(startGameButton)
        
        let shopMenuButton = SKSpriteNode(imageNamed: "Shop.png")
        shopMenuButton.size = CGSize(width: self.frame.size.width * 0.55, height: self.frame.size.height * 0.0675)
        shopMenuButton.zPosition = 1000
        shopMenuButton.position = CGPoint(x: self.frame.midX, y: self.frame.size.height * 0.45)
        shopMenuButton.name = "shopMenu"
        addChild(shopMenuButton)
        
        muteButton.text = "mute"
        muteButton.fontSize = self.frame.size.height * 0.055
        muteButton.zPosition = 1000
        muteButton.position = CGPoint(x: self.size.width * 0.285, y: self.size.height * 0.33)
        muteButton.name = "muteButton"
        
        unmuteButton.text = "unmute"
        unmuteButton.fontSize = self.frame.size.height * 0.055
        unmuteButton.zPosition = 1000
        unmuteButton.position = CGPoint(x: self.size.width * 0.285, y: self.size.height * 0.33)
        unmuteButton.name = "unmuteButton"
        
        if !mute {
            addChild(muteButton)
        }
        
        if mute {
            addChild(unmuteButton)
        }
        
        // LEADERBOARD
        leaderboardButton.text = "scores"
        leaderboardButton.fontSize = self.frame.size.height * 0.055
        leaderboardButton.zPosition = 1000
        leaderboardButton.position = CGPoint(x: self.size.width * 0.67, y: self.size.height * 0.33)
        leaderboardButton.name = "leaderboardButton"
        addChild(leaderboardButton)
        
        // HIGH SCHORE LABEL
        let highscore = SKSpriteNode(imageNamed: "Highscore.png")
        highscore.size = CGSize(width: self.frame.size.width * 0.525, height: self.frame.size.height * 0.0675)
        highscore.zPosition = 1000
        highscore.position = CGPoint(x: self.frame.size.width * 0.38, y: self.frame.size.height * 0.56)
        addChild(highscore)
        
        highScoreLabel.text = String(score)
        highScoreLabel.fontSize = self.frame.size.height * 0.05
        highScoreLabel.position = CGPoint(x: self.size.width * 0.71, y: self.size.height * 0.545)
        highScoreLabel.zPosition = 20000
        addChild(highScoreLabel)
        
        // BACKGROUND
        self.backgroundColor = SKColor.black
        
        let bgTexture = SKTexture(imageNamed: "MenuBG.png")
        let bg = SKSpriteNode(texture: bgTexture)
        bg.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        bg.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        bg.zPosition = 0
        self.addChild(bg)
    }
    
    // TOUCH
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        let touchLocation = touch!.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if touchedNode.name == "startGame" {
            if !mute {
                GameViewController.stopBackgroundMusic()
            }
            let transitionType = SKTransition.fade(withDuration: 1)
            let viewSize = self.view?.bounds.size
            let scene = GameScene(size: viewSize!)
            self.view?.presentScene(scene, transition: transitionType)
        }
        if touchedNode.name == "shopMenu" {
            let transitionType = SKTransition.fade(withDuration: 1)
            let viewSize = self.view?.bounds.size
            let scene = ShopMenu(size: viewSize!)
            self.view?.presentScene(scene, transition: transitionType)
        }
        if touchedNode.name == "muteButton" {
            UserDefaults.standard.set(true, forKey: "mute")
            UserDefaults.standard.synchronize()
            GameViewController.stopBackgroundMusic()
            self.addChild(unmuteButton)
            muteButton.removeFromParent()
        }
        if touchedNode.name == "unmuteButton" {
            UserDefaults.standard.set(false, forKey: "mute")
            UserDefaults.standard.synchronize()
            GameViewController.playBackgroundMusic("MainTheme.mp3")
            self.addChild(muteButton)
            unmuteButton.removeFromParent()
        }
        if touchedNode.name == "leaderboardButton" {
            self.showGameCenter()
        }
    }
    
    func showGameCenter() {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        let vc:UIViewController = self.view!.window!.rootViewController!
        vc.present(gameCenterViewController, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
