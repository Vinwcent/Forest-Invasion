//
//  Projectile.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 10/05/2021.
//

import SpriteKit

class Projectile: SKSpriteNode {
    
    let arrowBitmask:UInt32 = 0x1 << 2
    let enemyBitmask:UInt32 = 0x1 << 0
    let environmentBitmask:UInt32 = 0x1 << 3
    var celerity:CGFloat
    var durability:CGFloat
    var projectileSize:CGFloat
    var damage:CGFloat
    var projectileType: ProjectileType
    var firingDirection: Hero.FiringDirection
    
    enum ProjectileType {
        case arrow, shrapnel, fireball, grenade
    }
    
    init(type: ProjectileType, celerity: CGFloat, angle: CGFloat, hitbox: CGFloat, firingDirection: Hero.FiringDirection) {
        self.celerity = celerity
        self.firingDirection = firingDirection
        self.projectileType = type
        self.durability = CGFloat(Item.arrowDurability)
        self.projectileSize = CGFloat(Item.projectileSize)
        self.damage = Item.damage
        var texture: SKTexture = SKTexture(imageNamed: "arrow")
        if self.projectileType == .fireball {
            texture = SKTexture(imageNamed: "fireball1")
        } else if self.projectileType == .grenade {
            texture = SKTexture(imageNamed: "grenade")
        }
        super.init(texture: texture, color: UIColor.gray, size: texture.size())
        self.physicsBody = SKPhysicsBody(circleOfRadius: projectileSize*projectileSize*hitbox)
        self.zPosition=3
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = arrowBitmask
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = enemyBitmask
        
        if self.projectileType == .grenade {
            self.physicsBody?.linearDamping = 5
        } else if self.projectileType == .fireball {
            self.zRotation = angle
            self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "fireball1"),SKTexture(imageNamed: "fireball2"),SKTexture(imageNamed: "fireball3"),SKTexture(imageNamed: "fireball4"),SKTexture(imageNamed: "fireball5")], timePerFrame: 0.2)))
        } else {
            self.zRotation = angle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
