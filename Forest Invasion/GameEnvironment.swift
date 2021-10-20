//
//  GameEnvironment.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 19/05/2021.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    enum ShopType {
        case alchemistShop, blacksmithShop
    }
    
    // MARK: - GAME ENVIRONMENT

    func setupGameEnvironment(tileType: Map.TileType) {
        var gameBackground: SKSpriteNode
        var gameForeground: SKSpriteNode
        gameForeground=SKSpriteNode(imageNamed: "gameForeground")
        
        switch tileType {
        case .monster:
            gameBackground=SKSpriteNode(imageNamed: "gameBackground" + "\((map?.actualPosition[0])!)"+"\((map?.actualPosition[1])!)")
        case .monsterDiscovered:
            gameBackground=SKSpriteNode(imageNamed: "gameBackground" + "\((map?.actualPosition[0])!)"+"\((map?.actualPosition[1])!)")
        case .shop:
            let randomShopList: [ShopType] = [.alchemistShop, .blacksmithShop]
            let randomShop = randomShopList.randomElement()!
            setupShop(shopType: randomShop)
            gameBackground=SKSpriteNode(imageNamed: "gameBackgroundAlchemist")
            
        }
        
        // MARK: - SCALING
        
        let gameWidth = CGFloat(self.size.width)
        let gameHeight = CGFloat(7*self.size.height/10)
        let gamePosition = CGPoint(x: self.size.width/2, y: 5.5*self.size.height/10)
        
        gameBackground.scale(to: CGSize(width: gameWidth, height: gameHeight))
        gameBackground.position=gamePosition
        gameBackground.zPosition = 0
        self.addChild(gameBackground)
        
        gameForeground.scale(to: CGSize(width: gameWidth, height: gameHeight))
        gameForeground.position=gamePosition
        gameForeground.zPosition = 4
        self.addChild(gameForeground)
        
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 2*self.size.height/10, width: gameWidth, height: gameHeight ))
        self.physicsBody?.categoryBitMask = environmentBitmask
        
    }
    
    // MARK: - TOP AND DOWN HUD
    
    func setupTopHud() {
        topHud = SKSpriteNode(imageNamed: "topHud")
        let topHudWidth = CGFloat(self.size.width)
        let topHudHeight = CGFloat(self.size.height/10)
        let topHudPosition = CGPoint(x: self.size.width/2, y: 9.5*self.size.height/10)
        topHud?.scale(to: CGSize(width: topHudWidth, height: topHudHeight))
        topHud?.position = topHudPosition
        topHud?.zPosition = 4
        self.addChild(topHud!)
        
        let powerUpBox = SKSpriteNode(imageNamed: "powerUpBox")
        powerUpBox.size = self.setRealSize(width: (powerUpBox.texture?.size().width)!, height: (powerUpBox.texture?.size().height)!)
        powerUpBox.size = multiplySize(size: powerUpBox.size, multiplier: 0.75)
        powerUpBox.position = CGPoint(x: self.size.width/2,y: 2*self.size.height/10)
        powerUpBox.alpha = 1
        powerUpBox.zPosition = 6
        self.addChild(powerUpBox)
        
        
        amountOfCoinsLabel = SKLabelNode(fontNamed: "alagard")
        amountOfCoinsLabel?.fontSize = 20
        let amountOfCoinsLabelPosition = CGPoint(x: self.size.width/5, y: 9.5*self.size.height/10)
        amountOfCoinsLabel?.position = amountOfCoinsLabelPosition
        amountOfCoinsLabel?.zPosition = 5
        amountOfCoinsLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(amountOfCoinsLabel!)
        
        let coinIcon = SKSpriteNode(imageNamed: "coin1")
        coinIcon.position.x -= 30
        coinIcon.zPosition = 5
        coinIcon.size = self.setRealSize(width: (coinIcon.texture?.size().width)!, height: (coinIcon.texture?.size().height)!)
        coinIcon.size = multiplySize(size: coinIcon.size, multiplier: 1)
        coinIcon.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "coin1"),SKTexture(imageNamed: "coin2"),SKTexture(imageNamed: "coin3"),SKTexture(imageNamed: "coin4"),SKTexture(imageNamed: "coin5"),SKTexture(imageNamed: "coin6"),SKTexture(imageNamed: "coin7"),SKTexture(imageNamed: "coin8")], timePerFrame: 0.1)))
        amountOfCoinsLabel?.addChild(coinIcon)
        
        
        amountOfLivesLabel = SKLabelNode(fontNamed: "alagard")
        amountOfLivesLabel?.fontSize = 20
        let amountOfLivesLabelPosition = CGPoint(x: 2*self.size.width/5, y: 9.5*self.size.height/10)
        amountOfLivesLabel?.position = amountOfLivesLabelPosition
        amountOfLivesLabel?.zPosition = 5
        amountOfLivesLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(amountOfLivesLabel!)
        
        let lifeIcon = SKSpriteNode(imageNamed: "life")
        lifeIcon.position.x -= 30
        lifeIcon.zPosition = 5
        lifeIcon.size = self.setRealSize(width: (lifeIcon.texture?.size().width)!, height: (lifeIcon.texture?.size().height)!)
        lifeIcon.size = multiplySize(size: lifeIcon.size, multiplier: 1)
        amountOfLivesLabel?.addChild(lifeIcon)
        
        
        stageLabel = SKLabelNode(fontNamed: "alagard")
        stageLabel?.fontSize = 20
        let stageLabelPosition = CGPoint(x: 3*self.size.width/5, y: 9.5*self.size.height/10)
        stageLabel?.position = stageLabelPosition
        stageLabel?.zPosition = 5
        stageLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(stageLabel!)
        
        let stageIcon = SKSpriteNode(imageNamed: "paw")
        stageIcon.position.x -= 30
        stageIcon.zPosition = 5
        stageIcon.size = self.setRealSize(width: (stageIcon.texture?.size().width)!, height: (stageIcon.texture?.size().height)!)
        stageIcon.size = multiplySize(size: stageIcon.size, multiplier: 1)
        stageLabel?.addChild(stageIcon)
        
        
        amountOfEmeraldsLabel = SKLabelNode(fontNamed: "alagard")
        amountOfEmeraldsLabel?.fontSize = 20
        let amountOfEmeraldsLabelPosition = CGPoint(x: 4*self.size.width/5, y: 9.5*self.size.height/10)
        amountOfEmeraldsLabel?.position = amountOfEmeraldsLabelPosition
        amountOfEmeraldsLabel?.zPosition = 5
        amountOfEmeraldsLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(amountOfEmeraldsLabel!)
        
        let emeraldIcon = SKSpriteNode(imageNamed: "ruby1")
        emeraldIcon.position.x -= 30
        emeraldIcon.zPosition = 5
        emeraldIcon.size = self.setRealSize(width: (emeraldIcon.texture?.size().width)!, height: (emeraldIcon.texture?.size().height)!)
        emeraldIcon.size = multiplySize(size: emeraldIcon.size, multiplier: 1)
        emeraldIcon.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "ruby1"),SKTexture(imageNamed: "ruby2"),SKTexture(imageNamed: "ruby3"),SKTexture(imageNamed: "ruby4"),SKTexture(imageNamed: "ruby5"),SKTexture(imageNamed: "ruby6"),SKTexture(imageNamed: "ruby7"),SKTexture(imageNamed: "ruby8")], timePerFrame: 0.1)))
        amountOfEmeraldsLabel?.addChild(emeraldIcon)
    }
    
    func setupDownHud() {
        downHud = SKSpriteNode(imageNamed: "downHud2")
        let downHudWidth = CGFloat(self.size.width)
        let downHudHeight = CGFloat(2*self.size.height/10)
        let downHudPosition = CGPoint(x: self.size.width/2, y: self.size.height/10)
        downHud?.scale(to: CGSize(width: downHudWidth, height: downHudHeight))
        downHud?.position = downHudPosition
        downHud?.zPosition = 4
        self.addChild(downHud!)
    }
    
    func setupShop(shopType: ShopType) {
        var shopHouse: SKSpriteNode
        var seller: SKSpriteNode
        var shopSign: SKSpriteNode
        switch shopType {
        case .alchemistShop:
            shopHouse = SKSpriteNode(imageNamed: "alchemistShop1")
            seller = SKSpriteNode(imageNamed: "alchemist")
            shopSign = SKSpriteNode(imageNamed:"alchemistSign")
        case .blacksmithShop:
            shopHouse = SKSpriteNode(imageNamed: "blacksmithShop1")
            seller = SKSpriteNode(imageNamed: "blacksmith")
            shopSign = SKSpriteNode(imageNamed:"blacksmithSign")
            
        }
        shopHouse.size = self.setRealSize(width: shopHouse.texture!.size().width, height: shopHouse.texture!.size().height)
        shopHouse.size = self.multiplySize(size: shopHouse.size, multiplier: 1.5)
        shopHouse.zPosition = 2
        shopHouse.physicsBody = SKPhysicsBody(texture: shopHouse.texture!, size: shopHouse.size)
        shopHouse.physicsBody?.categoryBitMask = environmentBitmask
        shopHouse.physicsBody?.affectedByGravity = false
        shopHouse.physicsBody?.isDynamic = false
        shopHouse.position = CGPoint(x: self.size.width/2, y: 6.5*self.size.height/10)
        self.addChild(shopHouse)
        
        seller.size = self.setRealSize(width: seller.texture!.size().width, height: seller.texture!.size().height)
        seller.size = self.multiplySize(size: seller.size, multiplier: 1.5)
        seller.zPosition = 2
        seller.physicsBody = SKPhysicsBody(texture: seller.texture!, size: seller.size)
        seller.physicsBody?.categoryBitMask = environmentBitmask
        seller.physicsBody?.affectedByGravity = false
        seller.physicsBody?.isDynamic = false
        shopHouse.addChild(seller)
        seller.position = CGPoint(x: shopHouse.size.width/2, y: -3*shopHouse.size.height/4)
        
        shopSign.size = self.setRealSize(width: shopSign.texture!.size().width, height: shopSign.texture!.size().height)
        shopSign.size = self.multiplySize(size: shopSign.size, multiplier: 1.5)
        shopSign.zPosition = 2
        shopSign.physicsBody = SKPhysicsBody(texture: shopSign.texture!, size: shopSign.size)
        shopSign.physicsBody?.categoryBitMask = environmentBitmask
        shopSign.physicsBody?.affectedByGravity = false
        shopSign.physicsBody?.isDynamic = false
        shopHouse.addChild(shopSign)
        shopSign.position = CGPoint(x: -shopHouse.size.width/2, y: -3*shopHouse.size.height/4)
        
        setupTheItems()
        
    }
    
    
    func setupTheItems() {
        for i in 1..<4 {
            let itemBox = SKSpriteNode(imageNamed: "itemBox")
            itemBox.size = self.setRealSize(width: itemBox.texture!.size().width, height: itemBox.texture!.size().height)
            itemBox.size = self.multiplySize(size: itemBox.size, multiplier: 1.5)
            itemBox.zPosition = 1
            itemBox.position = CGPoint(x: CGFloat(i)*self.size.width/4, y: 4.5*self.size.height/10)
            self.addChild(itemBox)
            
            let randomItem = Item.remainingItems.randomElement()
            let item = Item(randomItem!)
            item.zPosition = 2
            item.size = self.setRealSize(width: item.texture!.size().width, height: item.texture!.size().height)
            item.position = itemBox.position
            self.addChild(item)
            
            let itemPriceLabel = SKLabelNode(fontNamed: "CraftPixNet Survival Kit")
            itemPriceLabel.fontColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            itemPriceLabel.fontSize = 30
            let itemPriceLabelPosition = CGPoint(x: 0 ,y: -50 )
            itemPriceLabel.position = itemPriceLabelPosition
            itemPriceLabel.zPosition = 2
            itemPriceLabel.text = "\(item.price)"+"$"
            itemPriceLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
            item.addChild(itemPriceLabel)
        }
        
    }
    
}
