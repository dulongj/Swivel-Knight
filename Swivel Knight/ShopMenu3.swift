//
//  ShopMenu3.swift
//  Swivel Knight
//
//  Created by Jeremy Dulong on 1/10/16.
//  Copyright © 2016 Sailboat Supercar. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class ShopMenu3: SKScene {
    
    // VARIABLES
    let goldenArrowsLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
    let goldenArrow = SKSpriteNode(imageNamed: "GoldenArrow.png")
    let pageLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
    let selectionFrame = SKSpriteNode(imageNamed: "DiamondGameOverFrame.png")
    let mute = UserDefaults.standard.bool(forKey: "mute")
    let selectionSound = SKAction.playSoundFileNamed("Select.wav", waitForCompletion: false)
    let unlockSound = SKAction.playSoundFileNamed("Unlock.wav", waitForCompletion: false)
    let purchaseGate1 = SKSpriteNode(imageNamed: "PurchaseGate.png")
    let purchasePrice1 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let purchaseGate2 = SKSpriteNode(imageNamed: "PurchaseGate.png")
    let purchasePrice2 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let purchaseGate3 = SKSpriteNode(imageNamed: "PurchaseGate.png")
    let purchasePrice3 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let purchaseGate4 = SKSpriteNode(imageNamed: "PurchaseGate.png")
    let purchasePrice4 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let purchaseGate5 = SKSpriteNode(imageNamed: "PurchaseGate.png")
    let purchasePrice5 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let purchaseGate6 = SKSpriteNode(imageNamed: "PurchaseGate.png")
    let purchasePrice6 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let purchaseGate7 = SKSpriteNode(imageNamed: "PurchaseGate.png")
    let purchasePrice7 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let purchaseGate8 = SKSpriteNode(imageNamed: "PurchaseGate.png")
    let purchasePrice8 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let purchaseGate9 = SKSpriteNode(imageNamed: "PurchaseGate.png")
    let purchasePrice9 = SKLabelNode(fontNamed: "Copperplate-Bold")
    
    // PURCHASES
    let unlock21 = UserDefaults.standard.bool(forKey: "unlock21")
    let unlock22 = UserDefaults.standard.bool(forKey: "unlock22")
    let unlock23 = UserDefaults.standard.bool(forKey: "unlock23")
    let unlock24 = UserDefaults.standard.bool(forKey: "unlock24")
    let unlock25 = UserDefaults.standard.bool(forKey: "unlock25")
    let unlock26 = UserDefaults.standard.bool(forKey: "unlock26")
    let unlock27 = UserDefaults.standard.bool(forKey: "unlock27")
    let unlock28 = UserDefaults.standard.bool(forKey: "unlock28")
    let unlock29 = UserDefaults.standard.bool(forKey: "unlock29")
    
    // DID MOVE TO VIEW
    override func didMove(to view: SKView) {
        
        setUpScene()
    }
    
    func setUpScene() {
        // BACKGROUND
        self.backgroundColor = SKColor.black
        
        // BACKGROUND FRAME
        let frame = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame.size = CGSize(width: self.frame.size.width, height: self.frame.size.height)
        frame.position = CGPoint(x: self.size.width / 2, y: self.frame.size.height / 2)
        frame.zPosition = 0
        addChild(frame)
        
        // MENU BUTTON
        let menuButton = SKSpriteNode(imageNamed: "MenuButton.png")
        menuButton.size = CGSize(width: self.frame.size.width * 0.65, height: self.frame.size.height * 0.085)
        menuButton.zPosition = 100
        menuButton.position = CGPoint(x: self.size.width * 0.35, y: (self.size.height * 0.94))
        menuButton.name = "menuButton"
        addChild(menuButton)
        
        // GOLDEN ARROWS LABEL
        let rotateArrow = SKAction.rotate(toAngle: CGFloat(M_PI * 0.25), duration: 0.0)
        goldenArrow.run(rotateArrow)
        goldenArrow.size = CGSize(width: (self.frame.size.width * 0.12) * 0.75, height: (self.frame.size.width * 0.025) * 0.75)
        goldenArrow.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.95)
        goldenArrow.zPosition = 100
        addChild(goldenArrow)
        
        goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
        goldenArrowsLabel.fontSize = self.frame.size.height * 0.035
        goldenArrowsLabel.position = CGPoint(x: self.size.width * 0.9, y: self.size.height * 0.935)
        goldenArrowsLabel.zPosition = 100
        addChild(goldenArrowsLabel)
        
        // SELECTION FRAME
        selectionFrame.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        selectionFrame.zPosition = 150
        
        if UserDefaults.standard.string(forKey: "knightColor") == "RedWhiteKnight.png" {
            selectionFrame.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.8)
            addChild(selectionFrame)
        }
        if UserDefaults.standard.string(forKey: "knightColor") == "TanKnight.png" {
            selectionFrame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.8)
            addChild(selectionFrame)
        }
        if UserDefaults.standard.string(forKey: "knightColor") == "TanBlueKnight.png" {
            selectionFrame.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.8)
            addChild(selectionFrame)
        }
        if UserDefaults.standard.string(forKey: "knightColor") == "TealKnight.png" {
            selectionFrame.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.5)
            addChild(selectionFrame)
        }
        if UserDefaults.standard.string(forKey: "knightColor") == "TealWhiteKnight.png" {
            selectionFrame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
            addChild(selectionFrame)
        }
        if UserDefaults.standard.string(forKey: "knightColor") == "WhiteKnight.png" {
            selectionFrame.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.5)
            addChild(selectionFrame)
        }
        if UserDefaults.standard.string(forKey: "knightColor") == "WhiteRedKnight.png" {
            selectionFrame.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.2)
            addChild(selectionFrame)
        }
        if UserDefaults.standard.string(forKey: "knightColor") == "GoldKnight.png" {
            selectionFrame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
            addChild(selectionFrame)
        }
        if UserDefaults.standard.string(forKey: "knightColor") == "GoldGoldKnight.png" {
            selectionFrame.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.2)
            addChild(selectionFrame)
        }
        
        // ITEM FRAMES
        // 1
        let frame1 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame1.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        frame1.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.8)
        frame1.zPosition = 100
        frame1.name = "frame1"
        addChild(frame1)
        
        let item1 = SKSpriteNode(imageNamed: "RedWhiteKnight.png")
        item1.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        item1.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.8)
        item1.zPosition = 200
        item1.name = "item1"
        addChild(item1)
        
        if !unlock21 {
            purchaseGate1.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
            purchaseGate1.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.8)
            purchaseGate1.zPosition = 300
            purchaseGate1.name = "purchaseGate1"
            addChild(purchaseGate1)
            
            purchasePrice1.text = "50"
            purchasePrice1.fontSize = self.frame.size.height * 0.035
            purchasePrice1.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.785)
            purchasePrice1.zPosition = 400
            purchasePrice1.name = "purchasePrice1"
            addChild(purchasePrice1)
        }
        // 2
        let frame2 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame2.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        frame2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.8)
        frame2.zPosition = 100
        frame2.name = "frame2"
        addChild(frame2)
        
        let item2 = SKSpriteNode(imageNamed: "TanKnight.png")
        item2.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        item2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.8)
        item2.zPosition = 200
        item2.name = "item2"
        addChild(item2)
        
        if !unlock22 {
            purchaseGate2.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
            purchaseGate2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.8)
            purchaseGate2.zPosition = 300
            purchaseGate2.name = "purchaseGate2"
            addChild(purchaseGate2)
            
            purchasePrice2.text = "50"
            purchasePrice2.fontSize = self.frame.size.height * 0.035
            purchasePrice2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.785)
            purchasePrice2.zPosition = 400
            purchasePrice2.name = "purchasePrice2"
            addChild(purchasePrice2)
        }
        // 3
        let frame3 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame3.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        frame3.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.8)
        frame3.zPosition = 100
        frame3.name = "frame3"
        addChild(frame3)
        
        let item3 = SKSpriteNode(imageNamed: "TanBlueKnight.png")
        item3.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        item3.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.8)
        item3.zPosition = 200
        item3.name = "item3"
        addChild(item3)
        
        if !unlock23 {
            purchaseGate3.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
            purchaseGate3.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.8)
            purchaseGate3.zPosition = 300
            purchaseGate3.name = "purchaseGate3"
            addChild(purchaseGate3)
            
            purchasePrice3.text = "50"
            purchasePrice3.fontSize = self.frame.size.height * 0.035
            purchasePrice3.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.785)
            purchasePrice3.zPosition = 400
            purchasePrice3.name = "purchasePrice3"
            addChild(purchasePrice3)
        }
        // 4
        let frame4 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame4.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        frame4.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.5)
        frame4.zPosition = 100
        frame4.name = "frame4"
        addChild(frame4)
        
        let item4 = SKSpriteNode(imageNamed: "TealKnight.png")
        item4.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        item4.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.5)
        item4.zPosition = 200
        item4.name = "item4"
        addChild(item4)
        
        if !unlock24 {
            purchaseGate4.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
            purchaseGate4.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.5)
            purchaseGate4.zPosition = 300
            purchaseGate4.name = "purchaseGate4"
            addChild(purchaseGate4)
            
            purchasePrice4.text = "50"
            purchasePrice4.fontSize = self.frame.size.height * 0.035
            purchasePrice4.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.485)
            purchasePrice4.zPosition = 400
            purchasePrice4.name = "purchasePrice4"
            addChild(purchasePrice4)
        }
        // 5
        let frame5 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame5.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        frame5.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        frame5.zPosition = 100
        frame5.name = "frame5"
        addChild(frame5)
        
        let item5 = SKSpriteNode(imageNamed: "TealWhiteKnight.png")
        item5.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        item5.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        item5.zPosition = 200
        item5.name = "item5"
        addChild(item5)
        
        if !unlock25 {
            purchaseGate5.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
            purchaseGate5.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
            purchaseGate5.zPosition = 300
            purchaseGate5.name = "purchaseGate5"
            addChild(purchaseGate5)
            
            purchasePrice5.text = "50"
            purchasePrice5.fontSize = self.frame.size.height * 0.035
            purchasePrice5.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.485)
            purchasePrice5.zPosition = 400
            purchasePrice5.name = "purchasePrice5"
            addChild(purchasePrice5)
        }
        // 6
        let frame6 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame6.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        frame6.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.5)
        frame6.zPosition = 100
        frame6.name = "frame6"
        addChild(frame6)
        
        let item6 = SKSpriteNode(imageNamed: "WhiteKnight.png")
        item6.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        item6.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.5)
        item6.zPosition = 200
        item6.name = "item6"
        addChild(item6)
        
        if !unlock26 {
            purchaseGate6.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
            purchaseGate6.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.5)
            purchaseGate6.zPosition = 300
            purchaseGate6.name = "purchaseGate6"
            addChild(purchaseGate6)
            
            purchasePrice6.text = "50"
            purchasePrice6.fontSize = self.frame.size.height * 0.035
            purchasePrice6.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.485)
            purchasePrice6.zPosition = 400
            purchasePrice6.name = "purchasePrice6"
            addChild(purchasePrice6)
        }
        // 7
        let frame7 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame7.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        frame7.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.2)
        frame7.zPosition = 100
        frame7.name = "frame7"
        addChild(frame7)
        
        let item7 = SKSpriteNode(imageNamed: "WhiteRedKnight.png")
        item7.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        item7.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.2)
        item7.zPosition = 200
        item7.name = "item7"
        addChild(item7)
        
        if !unlock27 {
            purchaseGate7.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
            purchaseGate7.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.2)
            purchaseGate7.zPosition = 300
            purchaseGate7.name = "purchaseGate7"
            addChild(purchaseGate7)
            
            purchasePrice7.text = "50"
            purchasePrice7.fontSize = self.frame.size.height * 0.035
            purchasePrice7.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.185)
            purchasePrice7.zPosition = 400
            purchasePrice7.name = "purchasePrice7"
            addChild(purchasePrice7)
        }
        // 8
        let frame8 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame8.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        frame8.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
        frame8.zPosition = 100
        frame8.name = "frame8"
        addChild(frame8)
        
        let item8 = SKSpriteNode(imageNamed: "GoldKnight.png")
        item8.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        item8.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
        item8.zPosition = 200
        item8.name = "item8"
        addChild(item8)
        
        if !unlock28 {
            purchaseGate8.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
            purchaseGate8.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
            purchaseGate8.zPosition = 300
            purchaseGate8.name = "purchaseGate8"
            addChild(purchaseGate8)
            
            purchasePrice8.text = "100"
            purchasePrice8.fontSize = self.frame.size.height * 0.035
            purchasePrice8.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.185)
            purchasePrice8.zPosition = 400
            purchasePrice8.name = "purchasePrice8"
            addChild(purchasePrice8)
        }
        // 9
        let frame9 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame9.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
        frame9.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.2)
        frame9.zPosition = 100
        frame9.name = "frame9"
        addChild(frame9)
        
        let item9 = SKSpriteNode(imageNamed: "GoldGoldKnight.png")
        item9.size = CGSize(width: self.frame.size.width * 0.15, height: self.frame.size.width * 0.13)
        item9.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.2)
        item9.zPosition = 200
        item9.name = "item9"
        addChild(item9)
        
        if !unlock29 {
            purchaseGate9.size = CGSize(width: self.size.width * 0.25, height: self.size.height * 0.2)
            purchaseGate9.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.2)
            purchaseGate9.zPosition = 300
            purchaseGate9.name = "purchaseGate9"
            addChild(purchaseGate9)
            
            purchasePrice9.text = "150"
            purchasePrice9.fontSize = self.frame.size.height * 0.035
            purchasePrice9.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.185)
            purchasePrice9.zPosition = 400
            purchasePrice9.name = "purchasePrice9"
            addChild(purchasePrice9)
        }
        
        // PAGE CHANGERS
        pageLabel.text = "Page 3"
        pageLabel.fontSize = self.frame.size.height * 0.035
        pageLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.04)
        pageLabel.zPosition = 100
        addChild(pageLabel)
        
        let nextButton = SKSpriteNode(imageNamed: "NextButton.png")
        nextButton.size = CGSize(width: self.size.width * 0.3, height: self.size.height * 0.04)
        nextButton.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.05)
        nextButton.zPosition = 100
        nextButton.name = "nextButton"
        addChild(nextButton)
        
        let lastButton = SKSpriteNode(imageNamed: "LastButton.png")
        lastButton.size = CGSize(width: self.size.width * 0.3, height: self.size.height * 0.04)
        lastButton.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.05)
        lastButton.zPosition = 100
        lastButton.name = "lastButton"
        addChild(lastButton)
    }
    
    // TOUCH
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as UITouch?
        let touchLocation = touch!.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        if touchedNode.name == "menuButton" {
            let transitionType = SKTransition.fade(withDuration: 1)
            let viewSize = self.view?.bounds.size
            let scene = MainMenu(size: viewSize!)
            self.view?.presentScene(scene, transition: transitionType)
        }
        if touchedNode.name == "nextButton" {
            let viewSize = self.view?.bounds.size
            let scene = ShopMenu4(size: viewSize!)
            self.view?.presentScene(scene)
        }
        if touchedNode.name == "lastButton" {
            let viewSize = self.view?.bounds.size
            let scene = ShopMenu2(size: viewSize!)
            self.view?.presentScene(scene)
        }
        if touchedNode.name == "item1" || touchedNode.name == "frame1" {
            if !mute {
                self.run(selectionSound)
            }
            selectionFrame.removeFromParent()
            selectionFrame.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.8)
            addChild(selectionFrame)
            UserDefaults.standard.setValue("RedWhiteKnight.png", forKey: "knightColor")
            UserDefaults.standard.setValue("RedWhiteShield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
        if touchedNode.name == "item2" || touchedNode.name == "frame2" {
            if !mute {
                self.run(selectionSound)
            }
            selectionFrame.removeFromParent()
            selectionFrame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.8)
            addChild(selectionFrame)
            UserDefaults.standard.setValue("TanKnight.png", forKey: "knightColor")
            UserDefaults.standard.setValue("TanShield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
        if touchedNode.name == "item3" || touchedNode.name == "frame3" {
            if !mute {
                self.run(selectionSound)
            }
            selectionFrame.removeFromParent()
            selectionFrame.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.8)
            addChild(selectionFrame)
            UserDefaults.standard.setValue("TanBlueKnight.png", forKey: "knightColor")
            UserDefaults.standard.setValue("TanBlueShield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
        if touchedNode.name == "item4" || touchedNode.name == "frame4" {
            if !mute {
                self.run(selectionSound)
            }
            selectionFrame.removeFromParent()
            selectionFrame.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.5)
            addChild(selectionFrame)
            UserDefaults.standard.setValue("TealKnight.png", forKey: "knightColor")
            UserDefaults.standard.setValue("TealShield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
        if touchedNode.name == "item5" || touchedNode.name == "frame5" {
            if !mute {
                self.run(selectionSound)
            }
            selectionFrame.removeFromParent()
            selectionFrame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
            addChild(selectionFrame)
            UserDefaults.standard.setValue("TealWhiteKnight.png", forKey: "knightColor")
            UserDefaults.standard.setValue("TealWhiteShield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
        if touchedNode.name == "item6" || touchedNode.name == "frame6" {
            if !mute {
                self.run(selectionSound)
            }
            selectionFrame.removeFromParent()
            selectionFrame.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.5)
            addChild(selectionFrame)
            UserDefaults.standard.setValue("WhiteKnight.png", forKey: "knightColor")
            UserDefaults.standard.setValue("WhiteShield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
        if touchedNode.name == "item7" || touchedNode.name == "frame7" {
            if !mute {
                self.run(selectionSound)
            }
            selectionFrame.removeFromParent()
            selectionFrame.position = CGPoint(x: self.size.width * 0.225, y: self.size.height * 0.2)
            addChild(selectionFrame)
            UserDefaults.standard.setValue("WhiteRedKnight.png", forKey: "knightColor")
            UserDefaults.standard.setValue("WhiteRedShield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
        if touchedNode.name == "item8" || touchedNode.name == "frame8" {
            if !mute {
                self.run(selectionSound)
            }
            selectionFrame.removeFromParent()
            selectionFrame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
            addChild(selectionFrame)
            UserDefaults.standard.setValue("GoldKnight.png", forKey: "knightColor")
            UserDefaults.standard.setValue("GoldShield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
        if touchedNode.name == "item9" || touchedNode.name == "frame9" {
            if !mute {
                self.run(selectionSound)
            }
            selectionFrame.removeFromParent()
            selectionFrame.position = CGPoint(x: self.size.width * 0.775, y: self.size.height * 0.2)
            addChild(selectionFrame)
            UserDefaults.standard.setValue("GoldGoldKnight.png", forKey: "knightColor")
            UserDefaults.standard.setValue("GoldGoldShield.png", forKey: "shieldColor")
            UserDefaults.standard.synchronize()
        }
        if (touchedNode.name == "purchaseGate1" || touchedNode.name == "purchasePrice1") && UserDefaults.standard.integer(forKey: "goldenArrows") >= 50 {
            if !mute {
                self.run(unlockSound)
            }
            purchasePrice1.removeFromParent()
            purchaseGate1.removeFromParent()
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") - 50, forKey: "goldenArrows")
            goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
            UserDefaults.standard.set(true, forKey: "unlock21")
            UserDefaults.standard.synchronize()
        }
        if (touchedNode.name == "purchaseGate2" || touchedNode.name == "purchasePrice2") && UserDefaults.standard.integer(forKey: "goldenArrows") >= 50 {
            if !mute {
                self.run(unlockSound)
            }
            purchasePrice2.removeFromParent()
            purchaseGate2.removeFromParent()
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") - 50, forKey: "goldenArrows")
            goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
            UserDefaults.standard.set(true, forKey: "unlock22")
            UserDefaults.standard.synchronize()
        }
        if (touchedNode.name == "purchaseGate3" || touchedNode.name == "purchasePrice3") && UserDefaults.standard.integer(forKey: "goldenArrows") >= 50 {
            if !mute {
                self.run(unlockSound)
            }
            purchasePrice3.removeFromParent()
            purchaseGate3.removeFromParent()
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") - 50, forKey: "goldenArrows")
            goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
            UserDefaults.standard.set(true, forKey: "unlock23")
            UserDefaults.standard.synchronize()
        }
        if (touchedNode.name == "purchaseGate4" || touchedNode.name == "purchasePrice4") && UserDefaults.standard.integer(forKey: "goldenArrows") >= 50 {
            if !mute {
                self.run(unlockSound)
            }
            purchasePrice4.removeFromParent()
            purchaseGate4.removeFromParent()
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") - 50, forKey: "goldenArrows")
            goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
            UserDefaults.standard.set(true, forKey: "unlock24")
            UserDefaults.standard.synchronize()
        }
        if (touchedNode.name == "purchaseGate5" || touchedNode.name == "purchasePrice5") && UserDefaults.standard.integer(forKey: "goldenArrows") >= 50 {
            if !mute {
                self.run(unlockSound)
            }
            purchasePrice5.removeFromParent()
            purchaseGate5.removeFromParent()
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") - 50, forKey: "goldenArrows")
            goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
            UserDefaults.standard.set(true, forKey: "unlock25")
            UserDefaults.standard.synchronize()
        }
        if (touchedNode.name == "purchaseGate6" || touchedNode.name == "purchasePrice6") && UserDefaults.standard.integer(forKey: "goldenArrows") >= 50 {
            if !mute {
                self.run(unlockSound)
            }
            purchasePrice6.removeFromParent()
            purchaseGate6.removeFromParent()
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") - 50, forKey: "goldenArrows")
            goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
            UserDefaults.standard.set(true, forKey: "unlock26")
            UserDefaults.standard.synchronize()
        }
        if (touchedNode.name == "purchaseGate7" || touchedNode.name == "purchasePrice7") && UserDefaults.standard.integer(forKey: "goldenArrows") >= 50 {
            if !mute {
                self.run(unlockSound)
            }
            purchasePrice7.removeFromParent()
            purchaseGate7.removeFromParent()
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") - 50, forKey: "goldenArrows")
            goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
            UserDefaults.standard.set(true, forKey: "unlock27")
            UserDefaults.standard.synchronize()
        }
        if (touchedNode.name == "purchaseGate8" || touchedNode.name == "purchasePrice8") && UserDefaults.standard.integer(forKey: "goldenArrows") >= 100 {
            if !mute {
                self.run(unlockSound)
            }
            purchasePrice8.removeFromParent()
            purchaseGate8.removeFromParent()
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") - 100, forKey: "goldenArrows")
            goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
            UserDefaults.standard.set(true, forKey: "unlock28")
            UserDefaults.standard.synchronize()
        }
        if (touchedNode.name == "purchaseGate9" || touchedNode.name == "purchasePrice9") && UserDefaults.standard.integer(forKey: "goldenArrows") >= 150 {
            if !mute {
                self.run(unlockSound)
            }
            purchasePrice9.removeFromParent()
            purchaseGate9.removeFromParent()
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "goldenArrows") - 150, forKey: "goldenArrows")
            goldenArrowsLabel.text = String(UserDefaults.standard.integer(forKey: "goldenArrows"))
            UserDefaults.standard.set(true, forKey: "unlock29")
            UserDefaults.standard.synchronize()
        }
    }
}
