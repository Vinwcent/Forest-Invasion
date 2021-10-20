//
//  Item.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 19/05/2021.
//

import SpriteKit

class Item: SKSpriteNode {
    
    let enemyBitmask:UInt32 = 0x1 << 0
    let playerBitmask:UInt32 = 0x1 << 1
    let arrowBitmask:UInt32 = 0x1 << 2
    let environmentBitmask:UInt32 = 0x1 << 3
    let powerUpBitmask:UInt32 = 0x1 << 4
    let itemBitmask:UInt32 = 0x1 << 5
    var price: Int
    
    
    var itemName: Name
    
    enum Name {
        case piercingShot,shrapnel,bigArrow,fireball,damageUp, electricArrow, grenade, poisonedArrow, snakeVision, fearArrow, feather, fireRate, fireArrow, allyArrow
    }
    
    init(_ named: Name) {
        self.itemName = named
        var itemTexture: SKTexture
        
        
        switch itemName {
        case .piercingShot:
            itemTexture = SKTexture(imageNamed: "piercingShot")
            price = 5
        case .shrapnel:
            itemTexture = SKTexture(imageNamed: "shrapnel")
            price = 5
        case .bigArrow:
            itemTexture = SKTexture(imageNamed: "bigShot")
            price = 5
        case .fireball:
            itemTexture = SKTexture(imageNamed: "fireball")
            price = 5
        case .damageUp:
            itemTexture = SKTexture(imageNamed: "damageUp")
            price = 0
        case .electricArrow:
            itemTexture = SKTexture(imageNamed: "electricArrow")
            price = 0
        case .grenade:
            itemTexture = SKTexture(imageNamed: "grenade")
            price = 0
        case .poisonedArrow:
            itemTexture = SKTexture(imageNamed: "poisonedArrow")
            price = 0
        case .snakeVision:
            itemTexture = SKTexture(imageNamed: "snakeVision")
            price = 0
        case .fearArrow:
            itemTexture = SKTexture(imageNamed: "fearArrow")
            price = 0
        case .feather:
            itemTexture = SKTexture(imageNamed: "feather")
            price = 0
        case .fireRate:
            itemTexture = SKTexture(imageNamed: "fireRate")
            price = 0
        case .fireArrow:
            itemTexture = SKTexture(imageNamed: "fireArrow")
            price = 0
        case .allyArrow:
            itemTexture = SKTexture(imageNamed: "allyArrow")
            price = 0
        }
        
        super.init(texture: itemTexture, color: UIColor.gray, size: itemTexture.size())
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        self.zPosition = 2
        self.name = "ITEM"
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = itemBitmask
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = playerBitmask
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func giveStats() {
        switch itemName {
        case .piercingShot:
            Item.arrowDurability = 1
        case .shrapnel:
            Item.shrapnel = true
        case .bigArrow:
            Item.projectileSize = 2
        case .fireball:
            Item.fireball = true
        case .damageUp:
            Item.damage += 3
        case .electricArrow:
            Item.electricArrow = true
        case .grenade:
            Item.grenade = true
        case .poisonedArrow:
            Item.poisonedArrow = true
        case .snakeVision:
            Item.snakeVision = true
        case .fearArrow:
            Item.fearArrow = true
        case .feather:
            Item.projectileCelerity = 1500
        case .fireRate:
            Item.firingSpeed -= 2/5*Item.firingSpeed
        case .fireArrow:
            Item.fireArrow = true
        case .allyArrow:
            Item.allyArrow = true
        }
    }
    
    
    
    // MARK: ITEMS AND EDITABLE STATS
    
    static var remainingItems: [Item.Name] = [.allyArrow,.bigArrow,.damageUp,.electricArrow,.fearArrow,.feather,.fireArrow,.fireRate,.fireball,.grenade,.piercingShot,.shrapnel,.snakeVision]
    
    static var projectileSize = 1
    static var arrowDurability = 0
    static var shrapnel: Bool = false
    static var fireball = false
    static var electricArrow = false
    static var grenade = false
    static var poisonedArrow = false
    static var snakeVision = false
    static var fearArrow = false
    static var feather = false
    static var fireArrow = false
    static var allyArrow = false
    
    static var damage: CGFloat = 4
    static var firingSpeed: Double = 0.5
    static var walkingSpeed: CGFloat = 50
    static var projectileCelerity: CGFloat = 500
    
    static func reinitializeStats() {

        Item.projectileSize = 1
        Item.arrowDurability = 0
        Item.shrapnel = false
        Item.fireball = false
        Item.damage = 4
        Item.electricArrow = false
        Item.grenade = false
        Item.poisonedArrow = false
        Item.snakeVision = false
        Item.fearArrow = false
        Item.fireArrow = false
        Item.allyArrow = false
        
        Item.firingSpeed = 0.5
        Item.walkingSpeed = 50
        Item.projectileCelerity = 500
    }
    
}

