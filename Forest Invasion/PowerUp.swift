//
//  PowerUp.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 12/05/2021.
//

import SpriteKit

class PowerUp: SKSpriteNode {
    
    let enemyBitmask:UInt32 = 0x1 << 0
    let playerBitmask:UInt32 = 0x1 << 1
    let arrowBitmask:UInt32 = 0x1 << 2
    let environmentBitmask:UInt32 = 0x1 << 3
    let powerUpBitmask:UInt32 = 0x1 << 4
    var powerUp:PowerUpType
    
    var duration:Int
    
    enum PowerUpType {
        case gatling, trishot, boots, coin, ruby, sword
    }
    
    init(_ powerUp: PowerUpType) {
        self.powerUp = powerUp
        var powerUpTexture: SKTexture
        
        switch powerUp {
        case .gatling:
            duration = 10
            powerUpTexture = SKTexture(imageNamed: "gatling")
        case .trishot:
            powerUpTexture = SKTexture(imageNamed: "Shotgun")
            duration = 20
        case .boots:
            powerUpTexture = SKTexture(imageNamed: "boots")
            duration = 20
        case .coin:
            powerUpTexture = SKTexture(imageNamed: "coin1")
            duration = 3
        case .ruby:
            powerUpTexture = SKTexture(imageNamed: "ruby1")
            duration = 1
        case .sword:
            powerUpTexture = SKTexture(imageNamed: "sword")
            duration = 10
        }
        
        super.init(texture: powerUpTexture, color: UIColor.gray, size: powerUpTexture.size())
        if self.powerUp == .coin {
            self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "coin1"),SKTexture(imageNamed: "coin2"),SKTexture(imageNamed: "coin3"),SKTexture(imageNamed: "coin4"),SKTexture(imageNamed: "coin5"),SKTexture(imageNamed: "coin6"),SKTexture(imageNamed: "coin7"),SKTexture(imageNamed: "coin8")], timePerFrame: 0.1)))
        } else if self.powerUp == .ruby {
            self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "ruby1"),SKTexture(imageNamed: "ruby2"),SKTexture(imageNamed: "ruby3"),SKTexture(imageNamed: "ruby4"),SKTexture(imageNamed: "ruby5"),SKTexture(imageNamed: "ruby6"),SKTexture(imageNamed: "ruby7"),SKTexture(imageNamed: "ruby8")], timePerFrame: 0.1)))
        }
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        self.zPosition = 2
        self.name = "POWERUP"
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = powerUpBitmask
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = playerBitmask
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func giveBonus(player: Hero) -> TimeInterval {
        switch self.powerUp {
        case .gatling:
            Item.firingSpeed/=3
        case .trishot:
            player.fireType = .trishot
        case .boots:
            Item.walkingSpeed+=100
        case .coin:
            Hero.amountOfCoins += 1
            Item.walkingSpeed+=50
        case .ruby:
            GameHandler.sharedInstance.amountOfEmeralds += 1
            Item.walkingSpeed += 1
        case .sword:
            player.tornado = true
            player.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "tornado1"),SKTexture(imageNamed: "tornado2"),SKTexture(imageNamed: "tornado3"),SKTexture(imageNamed: "tornado4"),SKTexture(imageNamed: "tornado5")], timePerFrame: 0.05)))
        }
        return TimeInterval(duration)
    }
    
    func removeBonus(player: Hero) {
        switch self.powerUp {
        case .gatling:
            Item.firingSpeed*=3
        case .trishot:
            player.fireType = .classic
        case .boots:
            Item.walkingSpeed-=100
        case .coin:
            Item.walkingSpeed-=50
        case .ruby:
            Item.walkingSpeed -= 1
        case .sword:
            player.tornado = false
        }
    }
}
