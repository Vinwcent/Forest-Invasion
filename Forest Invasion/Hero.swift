//
//  Hero.swift
//  Invasion
//
//  Created by Vincent Van Wynendaele on 09/05/2021.
//

import SpriteKit

class Hero: SKSpriteNode {
    
    
    let playerBitmask:UInt32 = 0x1 << 1
    let enemyBitmask:UInt32 = 0x1 << 0
    let environmentBitmask:UInt32 = 0x1 << 3
    let borderBitmask:UInt32 = 0x1 << 4
    let itemBitmask:UInt32 = 0x1 << 5
    
    init(image: String) {
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: UIColor.gray, size: texture.size())
        let hitbox = texture.size().width
        self.physicsBody = SKPhysicsBody(circleOfRadius: hitbox)
        self.zPosition=2
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = playerBitmask
        self.physicsBody?.collisionBitMask = environmentBitmask
        self.physicsBody?.contactTestBitMask = enemyBitmask | borderBitmask | itemBitmask
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    enum Direction {
        case down, left, up, right
    }
    
    enum FiringDirection {
        case up,upRight,upLeft,down,downRight,downLeft,right,left
    }
    
    enum FireType {
        case classic,trishot
    }
    
    // MARK: - VAR/CONS
    
    static var lives:Int = 3
    static var amountOfCoins:Int = 0
    
    var isWalking: Bool = false
    var wasWalking: Bool = false
    var walkingDirection: Direction = .down
    
    var isFiring: Bool = false
    var wasFiring: Bool = false
    var firingDirection: FiringDirection = .down
    var fireType:FireType = .classic
    
    
    var tornado: Bool = false
    var immortal: Bool = false
    var hasPowerUp: Bool = false
    
    var direction: Direction = .down {
        didSet {
            if !self.tornado {
                setSprite(direction)
            }
        }
    }
    
    
    // MARK: - FUNCS
    
    private func setSprite(_ direction: Direction) {
        if (isFiring && !wasFiring) || (isFiring && walkingDirection != direction) {
            walkingDirection = direction
            wasFiring = isFiring
            self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Attack1"),SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Attack2"),SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Attack3")], timePerFrame: Item.firingSpeed/3)))
            
            guard let scene = self.scene as? GameScene else {return}
            self.size = scene.setRealSize(width: SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Attack1").size().width, height: SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Attack1").size().height)
        } else if !isFiring {
            if (isWalking && !wasWalking) || (isWalking && walkingDirection != direction) || (isWalking && wasFiring) {
                wasFiring = false
                walkingDirection = direction
                wasWalking = isWalking
                self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Walk1"),SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Walk2"),SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Walk3"),SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Walk4"),SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Walk5"),SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Walk6")], timePerFrame: 0.1)))
                guard let scene = self.scene as? GameScene else {return}
                self.size = scene.setRealSize(width: SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Walk1").size().width, height: SKTexture(imageNamed: "hero" + "\(direction)".capitalized + "Walk1").size().height)
            } else if !isWalking {
                self.removeAllActions()
                self.texture=SKTexture(imageNamed: "hero"+"\(direction)".capitalized)
                guard let scene = self.scene as? GameScene else {return}
                self.size = scene.setRealSize(width: SKTexture(imageNamed: "hero" + "\(direction)".capitalized).size().width, height: SKTexture(imageNamed: "hero" + "\(direction)".capitalized).size().height)
                wasWalking = false
                wasFiring = false
            }
        }
    }
    
    
    
    // MARK: - ITEMS
    
    
    
    
    
    
}


