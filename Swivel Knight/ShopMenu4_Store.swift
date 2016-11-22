//
//  ShopMenu4_Store.swift
//  Swivel Knight
//
//  Created by Jeremy Dulong on 1/17/16.
//  Copyright © 2016 Shepherd Mobile. All rights reserved.
//

import SpriteKit
import StoreKit

extension ShopMenu4 {
    
    func setUpPurchasing() {
        if (productIdentifiers.count != 0 && SKPaymentQueue.canMakePayments() == true) {
            purchasingEnabled = true
            SKPaymentQueue.default().add(self)
            requestProductData()
        }
    }
    
    func resetUpPurchasing() {
        if (productIdentifiers.count != 0 && SKPaymentQueue.canMakePayments() == true) {
            purchasingEnabled = true
            SKPaymentQueue.default().add(self)
            requestProductData()
        } else if (productIdentifiers.count == 0) {
            showAllBoughtAlert()
        } else {
            showOopsAlert()
        }
    }
    
    func requestProductData() {
        request = SKProductsRequest(productIdentifiers: self.productIdentifiers as Set<String>)
        request!.delegate = self
        request!.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products:[SKProduct] = response.products
        if (products.count != 0) {
            for returnedProduct in products {
                self.product = returnedProduct
                self.productsArray.append(product!)
            }
        } else {
            print("No products found")
        }
        let invalidProducts:[String] = response.invalidProductIdentifiers
        for invalidProduct in invalidProducts {
            print("Product not found \(invalidProduct)")
        }
    }
    
    func buyProduct(_ ID:String) {
        if SKPaymentQueue.canMakePayments() {
            for itemToBuy in productsArray {
                if (itemToBuy.productIdentifier == ID) {
                    let payment:SKPayment = SKPayment(product: itemToBuy)
                    SKPaymentQueue.default().add(payment)
                    break
                }
            }
        } else {
            resetUpPurchasing()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction was approved")
                self.deliverProduct(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case SKPaymentTransactionState.failed:
                print("Transaction failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func deliverProduct(_ transaction:SKPaymentTransaction) {
        defaults.set("Purchased", forKey: transaction.payment.productIdentifier)
        if (checkForConsumableItem(transaction.payment.productIdentifier) == true) {
            print("Found item in consumables dictionary")
        } else if (transaction.payment.productIdentifier == "UnlockAllKnights") {
            frame1.removeFromParent()
            line1.removeFromParent()
            line2.removeFromParent()
            line3.removeFromParent()
            line4.removeFromParent()
            UserDefaults.standard.set(true, forKey: "unlock2")
            UserDefaults.standard.set(true, forKey: "unlock3")
            UserDefaults.standard.set(true, forKey: "unlock4")
            UserDefaults.standard.set(true, forKey: "unlock5")
            UserDefaults.standard.set(true, forKey: "unlock6")
            UserDefaults.standard.set(true, forKey: "unlock7")
            UserDefaults.standard.set(true, forKey: "unlock8")
            UserDefaults.standard.set(true, forKey: "unlock9")
            UserDefaults.standard.set(true, forKey: "unlock11")
            UserDefaults.standard.set(true, forKey: "unlock12")
            UserDefaults.standard.set(true, forKey: "unlock13")
            UserDefaults.standard.set(true, forKey: "unlock14")
            UserDefaults.standard.set(true, forKey: "unlock15")
            UserDefaults.standard.set(true, forKey: "unlock16")
            UserDefaults.standard.set(true, forKey: "unlock17")
            UserDefaults.standard.set(true, forKey: "unlock18")
            UserDefaults.standard.set(true, forKey: "unlock19")
            UserDefaults.standard.set(true, forKey: "unlock21")
            UserDefaults.standard.set(true, forKey: "unlock22")
            UserDefaults.standard.set(true, forKey: "unlock23")
            UserDefaults.standard.set(true, forKey: "unlock24")
            UserDefaults.standard.set(true, forKey: "unlock25")
            UserDefaults.standard.set(true, forKey: "unlock26")
            UserDefaults.standard.set(true, forKey: "unlock27")
            UserDefaults.standard.set(true, forKey: "unlock28")
            UserDefaults.standard.set(true, forKey: "unlock29")
            UserDefaults.standard.synchronize()
        }
        else if (transaction.payment.productIdentifier == "RemoveAds") {
            frame2.removeFromParent()
            line5.removeFromParent()
            line6.removeFromParent()
            line7.removeFromParent()
        }
    }
    
    func checkForConsumableItem(_ productID:String) -> Bool {
        var found:Bool = false
        let path = Bundle.main.path(forResource: "Products", ofType: "plist")
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        if (dict.object(forKey: "Consumables") != nil) {
            if let consumables = dict.object(forKey: "Consumables") as? NSDictionary {
                for id in consumables {
                    if (id.key as! String == productID) {
                        found = true
                        if let productDict:NSDictionary = id.value as? NSDictionary {
                            for award in productDict {
                                let theAwardKey:String = award.key as! String
                                if let theAwardValue:Int = award.value as? Int {
                                    if (defaults.object(forKey: theAwardKey) != nil) {
                                        if let currentAmount:Int = defaults.integer(forKey: theAwardKey) {
                                            let newAmount = currentAmount + theAwardValue
                                            defaults.set(newAmount, forKey: theAwardKey)
                                        } else {
                                            defaults.set(theAwardValue, forKey: theAwardKey)
                                        }
                                    } else {
                                        defaults.set(theAwardValue, forKey: theAwardKey)
                                    }
                                } else {
                                    defaults.set(award.value as! String, forKey: theAwardKey)
                                }
                            }
                        }
                    }
                }
            }
        }
        return found
    }
    
    func restorePurchases() {
        restoreSilently = false
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func restorePurchasesSilently() {
        restoreSilently = true
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transacion:SKPaymentTransaction in queue.transactions {
            if (defaults.object(forKey: transacion.payment.productIdentifier) as! String != "Purchased") {
                defaults.set("Purchased", forKey: transacion.payment.productIdentifier)
                if (restoreSilently == false) {
                    // INDICATE RESTORE
                }
            }
        }
        if (restoreSilently == false) {
            showRestoreAlert()
        }
    }
    
    func showRestoreAlert() {
        let alert:UIAlertController = UIAlertController(title: "Thank You", message: "Your purchases have been restored.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        let vc:UIViewController = self.view!.window!.rootViewController!
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showAllBoughtAlert() {
        let alert:UIAlertController = UIAlertController(title: "Thank You", message: "Looks like you've bought everything.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        let vc:UIViewController = self.view!.window!.rootViewController!
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showOopsAlert() {
        let alert:UIAlertController = UIAlertController(title: "Oops", message: "You aren't able to purchase at this time. Check your iTunes settings.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            alertAction in
            alert.dismiss(animated: true, completion: nil)
        }))
        let vc:UIViewController = self.view!.window!.rootViewController!
        vc.present(alert, animated: true, completion: nil)
    }
}
