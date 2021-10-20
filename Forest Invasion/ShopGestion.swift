//
//  ShopGestion.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 19/05/2021.
//

import SpriteKit
import GameplayKit

extension ShopGameScene {
    
    func setupTheSeller() {
        let seller = SKSpriteNode(imageNamed: "seller")
        seller.size = setRealSize(width: (seller.texture?.size().width)!, height: (seller.texture?.size().height)!)
        seller.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        seller.physicsBody?.categoryBitMask = environmentBitmask
        seller.physicsBody?.affectedByGravity = false
        seller.physicsBody?.isDynamic = false
        seller.position = CGPoint(x: self.size.width/2, y: 6.25*self.size.height/10)
        seller.zPosition = 2
        self.playAnimation(animation: "wisp", position: seller.position)
        self.addChild(seller)
    }
    
    func setupTheItems() {
        for i in 0..<4 {
            let randomItem = Item.remainingItems.randomElement()
            let item = Item(randomItem!)
            item.zPosition = 2
            if i == 0 {
                item.position = CGPoint(x: 3*self.size.width/10,y: 6.25*self.size.height/10)
            } else if i == 1 {
                item.position = CGPoint(x: 7*self.size.width/10,y: 6.25*self.size.height/10)
            } else if i == 2 {
                item.position = CGPoint(x: 3*self.size.width/10,y: 3.75*self.size.height/10)
            } else {
                item.position = CGPoint(x: 7*self.size.width/10,y: 3.75*self.size.height/10)
            }
            self.playAnimation(animation: "wisp", position: item.position)
            self.addChild(item)
            
            let itemPriceLabel = SKLabelNode(fontNamed: "Noteworthy")
            itemPriceLabel.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            itemPriceLabel.fontSize = 15
            let itemPriceLabelPosition = CGPoint(x: 0 ,y: -15 )
            itemPriceLabel.position = itemPriceLabelPosition
            itemPriceLabel.zPosition = 2
            itemPriceLabel.text = "\(item.price)"
            itemPriceLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            item.addChild(itemPriceLabel)
        }
    }
    
    
    
    func playAnimation(animation: String, position: CGPoint) {
        if animation == "death" {
            let texture = SKSpriteNode(imageNamed: "enemyDeath1")
            texture.size = self.setRealSize(width: (texture.texture?.size().width)! , height: (texture.texture?.size().height)!)
            texture.position = position
            texture.zPosition = 3
            self.addChild(texture)
            texture.run(SKAction.sequence([SKAction.animate(with: [SKTexture(imageNamed: "enemyDeath1"),SKTexture(imageNamed: "enemyDeath2"),SKTexture(imageNamed: "enemyDeath3"),SKTexture(imageNamed: "enemyDeath4"),SKTexture(imageNamed: "enemyDeath5"),SKTexture(imageNamed: "enemyDeath6")], timePerFrame: 0.1), SKAction.run {
                texture.removeFromParent()
            }]))
        } else if animation == "smoke" {
            let texture = SKSpriteNode(imageNamed: "smoke1")
            texture.size = self.setRealSize(width: (texture.texture?.size().width)! , height: (texture.texture?.size().height)!)
            texture.position = position
            texture.zPosition = 3
            self.addChild(texture)
            texture.run(SKAction.sequence([SKAction.animate(with: [SKTexture(imageNamed: "smoke1"),SKTexture(imageNamed: "smoke2"),SKTexture(imageNamed: "smoke3"),SKTexture(imageNamed: "smoke4"),SKTexture(imageNamed: "smoke5"),SKTexture(imageNamed: "smoke6"),SKTexture(imageNamed: "smoke7"),SKTexture(imageNamed: "smoke8"),SKTexture(imageNamed: "smoke9"),SKTexture(imageNamed: "smoke10"),SKTexture(imageNamed: "smoke11"),SKTexture(imageNamed: "smoke12"),SKTexture(imageNamed: "smoke13"),SKTexture(imageNamed: "smoke14"),SKTexture(imageNamed: "smoke15"),SKTexture(imageNamed: "smoke16"),SKTexture(imageNamed: "smoke17")], timePerFrame: 0.05), SKAction.run {
                texture.removeFromParent()
            }]))
        } else if animation == "wisp" {
            let texture = SKSpriteNode(imageNamed: "wisp1")
            texture.size = self.setRealSize(width: 2*(texture.texture?.size().width)! , height: 2*(texture.texture?.size().height)!)
            texture.position = position
            texture.zPosition = 3
            self.addChild(texture)
            texture.run(SKAction.sequence([SKAction.animate(with: [SKTexture(imageNamed: "wisp1"),SKTexture(imageNamed: "wisp2"),SKTexture(imageNamed: "wisp3"),SKTexture(imageNamed: "wisp4"),SKTexture(imageNamed: "wisp5"),SKTexture(imageNamed: "wisp6"),SKTexture(imageNamed: "wisp7"),SKTexture(imageNamed: "wisp8"),SKTexture(imageNamed: "wisp9"),SKTexture(imageNamed: "wisp10"),SKTexture(imageNamed: "wisp11"),SKTexture(imageNamed: "wisp12"),SKTexture(imageNamed: "wisp13"),SKTexture(imageNamed: "wisp14"),SKTexture(imageNamed: "wisp15"),SKTexture(imageNamed: "wisp16"),SKTexture(imageNamed: "wisp17"),SKTexture(imageNamed: "wisp18"),SKTexture(imageNamed: "wisp19"),SKTexture(imageNamed: "wisp20"),SKTexture(imageNamed: "wisp21"),SKTexture(imageNamed: "wisp22"),SKTexture(imageNamed: "wisp23"),SKTexture(imageNamed: "wisp24")], timePerFrame: 0.05), SKAction.run {
                texture.removeFromParent()
            }]))
        }
    }
}
