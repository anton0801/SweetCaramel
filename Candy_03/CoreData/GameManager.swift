//
//  GameManager.swift
//  Candy_03
//
//  Created by Behruz Norov on 30/10/24.
//

import Foundation
import UIKit

class GameManager {
    static let shared = GameManager()
    
    private let timeFreeze = "sugarSlowdown"
    private let sweetBoost = "blastCandy"
    private let powerBlast = "sweetMultiplier"
    private let coins = "coins"
    private let diamonts = "diamonts"
    private let level = "level"
    private let lastRewardTime = "lastRewardTime"
    private let currentPower = "currentPower"
    private let firstEnterMessage = "firstEnterMessage"
    
    private init() {}
    
    func initializeValues() {
        let defaults = UserDefaults.standard
        if defaults.value(forKey: timeFreeze) == nil {
            defaults.setValue(0, forKey: timeFreeze)
        }
        
        if defaults.value(forKey: sweetBoost) == nil {
            defaults.setValue(0, forKey: sweetBoost)
        }
        
        if defaults.value(forKey: powerBlast) == nil {
            defaults.setValue(0, forKey: powerBlast)
        }
        
        if defaults.value(forKey: coins) == nil {
            defaults.setValue(1000, forKey: coins)
        }
        
        if defaults.value(forKey: diamonts) == nil {
            defaults.setValue(100, forKey: diamonts)
        }
        
        if defaults.value(forKey: level) == nil {
            defaults.setValue(0, forKey: level)
        }
        
        if defaults.value(forKey: lastRewardTime) == nil {
            let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
            defaults.setValue(oneDayAgo, forKey: lastRewardTime)
        }
        
        if defaults.value(forKey: currentPower) == nil {
            defaults.setValue(0, forKey: currentPower)
        }
        
        if defaults.value(forKey: firstEnterMessage) == nil {
            defaults.setValue(true, forKey: firstEnterMessage)
        }
    }
    
    func updateValue(forKey key: String, value: Any) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    func updateCoins(coinsToAdd: Int) {
        let defaults = UserDefaults.standard
        let currentCoins = defaults.value(forKey: coins) as! Int
        updateValue(forKey: coins, value: currentCoins + coinsToAdd)
    }
    
    func minusCoins(coinsToMinus: Int) {
        let defaults = UserDefaults.standard
        let currentCoins = defaults.value(forKey: coins) as! Int
        updateValue(forKey: coins, value: currentCoins - coinsToMinus)
    }
    
    func levelUp() {
        let defaults = UserDefaults.standard
        let currentLevel = defaults.value(forKey: level) as! Int
        if currentLevel != 12 {
            updateValue(forKey: level, value: currentLevel + 1)
        }
    }
    
    func getValue(key: String) -> Any {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: key) as Any
    }
    
    func increaseGivenPrize(key: String) {
        let defaults = UserDefaults.standard
        let currentLevel = defaults.value(forKey: key) as! Int
        updateValue(forKey: key, value: currentLevel + 1)
    }
    
    func decreaseGivenPrize(key: String) {
        let defaults = UserDefaults.standard
        let currentLevel = defaults.value(forKey: key) as! Int
        updateValue(forKey: key, value: currentLevel - 1)
    }
    
    func showCoinsInLabel(label: UILabel, diamontLabel: UILabel) {
        let defaults = UserDefaults.standard
        let currentLevel = defaults.value(forKey: coins) as! Int
        let currentDiamonts = defaults.value(forKey: diamonts) as! Int
        label.text = "\(currentLevel)"
        diamontLabel.text = "\(currentDiamonts)"
    }
}


