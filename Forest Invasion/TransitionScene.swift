//
//  ShopGameScene.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 16/05/2021.
//

import SpriteKit
import GameplayKit

class TransitionScene: SKScene {
    
    var navigationController: UINavigationController?
    var map: Map?
    var directionToGo: Map.Direction?
    var stageLabel: SKLabelNode?
    
    func presentScene() {
        if map == nil {
            map =  Map()
            map?.position = CGPoint(x: self.size.width/2,y: self.size.height/4)
            map?.size = CGSize(width: 4*self.size.width/10, height: 4*self.size.width/10)
            map?.isShowed = false
            self.addChild(map!)
            map?.updateTheIndicator() // On update ici car dans l'init de map on aurait pas l'info sur la taille
        } else {
            map?.position = CGPoint(x: self.size.width/2,y: self.size.height/4)
            map?.size = CGSize(width: 4*self.size.width/10, height: 4*self.size.width/10)
            map?.isShowed = false
            self.addChild(map!)
        }
        stageLabel = SKLabelNode(fontNamed: "CraftPixNet Survival Kit")
        stageLabel?.fontSize = 30
        stageLabel?.fontColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        stageLabel?.text = "Stage \(Int(Stage.currentStage))"
        stageLabel?.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        stageLabel?.zPosition = 2
        self.addChild(stageLabel!)
        
        
        
        if let direction = directionToGo {
            map?.updateTheMap(direction: direction)
        }
        
    }
    
    
    func goNextScene() {
        let transition = SKTransition.fade(withDuration: 1)
        let gameScene = SKScene(fileNamed: "GameScene") as! GameScene
        gameScene.scaleMode = .resizeFill
        gameScene.navigationController = self.navigationController
        gameScene.map = self.map
        map?.removeFromParent()
        self.view?.presentScene(gameScene, transition: transition)
    }
    
    override func didMove(to view: SKView) {
        self.presentScene()
        self.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run {
            self.goNextScene()
        }]))
    }
    
    
    
    
}
