//
//  ShopMenu4.swift
//  Swivel Knight
//
//  Created by Jeremy Dulong on 1/14/16.
//  Copyright © 2016 Sailboat Supercar. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import StoreKit

class ShopMenu4: SKScene, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // VARIABLES
    let goldenArrowsLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
    let goldenArrow = SKSpriteNode(imageNamed: "GoldenArrow.png")
    let pageLabel = SKLabelNode(fontNamed: "Copperplate-Bold")
    let line1 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let line2 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let line3 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let line4 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let line5 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let line6 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let line7 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let line8 = SKLabelNode(fontNamed: "Copperplate-Bold")
    let frame1 = SKSpriteNode(imageNamed: "SilverGameOverFrame.png")
    let frame2 = SKSpriteNode(imageNamed: "SilverGameOverFrame.png")
    
    // IN APP PURCHASES
    let unlockAllKnights = UserDefaults.standard.string(forKey: "UnlockAllKnights")
    
    var product:SKProduct?
    var productsArray = [SKProduct]()
    var productIdentifiers = Set<String>()
    var restoreSilently:Bool = true
    var request:SKProductsRequest?
    var purchasingEnabled:Bool = false
    
    let defaults:UserDefaults = UserDefaults.standard
    
    func parsePropertyList() {
        let path = Bundle.main.path(forResource: "Products", ofType: "plist")
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        if (dict.object(forKey: "Non-Consumables") != nil) {
            if let nonConsumables:NSArray = dict.object(forKey: "Non-Consumables") as? NSArray {
                for id in nonConsumables {
                    if let idString:String = id as? String {
                        if (defaults.object(forKey: idString) != nil) {
                            if (defaults.object(forKey: idString) as! String != "Purchased") {
                                defaults.set("Unpurchased", forKey: idString)
                                productIdentifiers.insert(idString)
                            }
                        } else {
                            defaults.set("Unpurchased", forKey: idString)
                            productIdentifiers.insert(idString)
                        }
                    }
                }
            }
        }
        if (dict.object(forKey: "Consumables") != nil) {
            if let consumables = dict.object(forKey: "Consumables") as? NSDictionary {
                for id in consumables {
                    productIdentifiers.insert(id.key as! String)
                }
            }
        }
    }
    
    // DID MOVE TO VIEW
    override func didMove(to view: SKView) {
        
        parsePropertyList()
        setUpPurchasing()
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
        
        // ITEM FRAMES
        if (unlockAllKnights != "Purchased") {
            // 1
            frame1.size = CGSize(width: self.size.width * 0.42, height: self.size.height * 0.34)
            frame1.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
            frame1.zPosition = 100
            frame1.name = "frame1"
            addChild(frame1)
            
            line1.text = "UNLOCK"
            line2.text = "ALL"
            line3.text = "KNIGHTS"
            line4.text = "$1.99"
            line1.fontSize = frame.size.height * 0.045
            line2.fontSize = frame.size.height * 0.045
            line3.fontSize = frame.size.height * 0.045
            line4.fontSize = frame.size.height * 0.045
            line1.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.55)
            line2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.51)
            line3.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.47)
            line4.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.43)
            line1.zPosition = 150
            line2.zPosition = 150
            line3.zPosition = 150
            line4.zPosition = 150
            line1.name = "line1"
            line2.name = "line2"
            line3.name = "line3"
            line4.name = "line4"
            addChild(line1)
            addChild(line2)
            addChild(line3)
            addChild(line4)
        }
        
        // 3
        let frame3 = SKSpriteNode(imageNamed: "GameOverFrame.png")
        frame3.size = CGSize(width: self.size.width * 0.60, height: self.size.height * 0.05)
        frame3.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.2)
        frame3.zPosition = 100
        frame3.name = "frame3"
        addChild(frame3)
        
        line8.text = "RESTORE PURCHASES"
        line8.fontSize = frame.size.height * 0.025
        line8.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.19)
        line8.zPosition = 150
        line8.name = "line8"
        addChild(line8)
        
        // PAGE CHANGERS
        pageLabel.text = "Page 4"
        pageLabel.fontSize = self.frame.size.height * 0.035
        pageLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.04)
        pageLabel.zPosition = 100
        addChild(pageLabel)
        
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
        if touchedNode.name == "lastButton" {
            let viewSize = self.view?.bounds.size
            let scene = ShopMenu3(size: viewSize!)
            self.view?.presentScene(scene)
        }
        if touchedNode.name == "frame1" || touchedNode.name == "line1" || touchedNode.name == "line2" || touchedNode.name == "line3" || touchedNode.name == "line4" {
            buyProduct("UnlockAllKnights")
        }
        if touchedNode.name == "frame2" || touchedNode.name == "line5" || touchedNode.name == "line6" || touchedNode.name == "line7" {
            buyProduct("RemoveAds")
        }
        if touchedNode.name == "frame3" || touchedNode.name == "line8" {
            restorePurchases()
        }
    }
}
