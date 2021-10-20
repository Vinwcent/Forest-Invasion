//
//  GameHandler.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 16/05/2021.
//

import Foundation

class GameHandler {
    var amountOfEmeralds:Int
    
    class var sharedInstance:GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        
        return Singleton.instance
        
    }
    
    init() {
        amountOfEmeralds = 0
        
        let userDefaults = UserDefaults.standard
        amountOfEmeralds = userDefaults.integer(forKey: "amountOfEmeralds")
    }
    
    func saveGameStats() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(amountOfEmeralds, forKey: "amountOfEmeralds")
        userDefaults.synchronize()
    }
}
