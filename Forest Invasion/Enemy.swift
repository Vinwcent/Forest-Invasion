//
//  Enemy.swift
//  Invasion
//
//  Created by Vincent Van Wynendaele on 10/05/2021.
//

import SpriteKit
import GameplayKit

class Enemy: SKSpriteNode {
    
    enum EnemyType {
        case treant, mole, hiddenMole, whiteTreant, skeleton, mushroom1, ogre
    }
    
    enum Direction {
        case down, right, up, left
    }
    
    enum State {
        case none, poison, fire
    }
    
    let enemyBitmask:UInt32 = 0x1 << 0
    let playerBitmask:UInt32 = 0x1 << 1
    let arrowBitmask:UInt32 = 0x1 << 2
    let environmentBitmask:UInt32 = 0x1 << 3
    let undergroundBitmask:UInt32 = 0x1 << 6
    
    
    var runningSpeed:CGFloat = 0
    var hitbox: CGFloat = 0
    var life: CGFloat = 1
    var feared: Bool = false
    var state: State = .none
    var direction:Direction = .down {
        didSet {
            setSprite(direction)
        }
    }
    var type:EnemyType
    
    init(type: EnemyType) {
        self.type = type
        var texture: SKTexture
        switch type {
        case .treant:
            texture = SKTexture(imageNamed:"treantDownWalk1")
            self.life = 10
        case .hiddenMole:
            texture = SKTexture(imageNamed:"hiddenMole")
            self.life = 1
        case .mole:
            texture = SKTexture(imageNamed:"moleDownWalk1")
            self.life = 6
        case .whiteTreant:
            texture = SKTexture(imageNamed:"whiteTreantDownWalk1")
            self.life = 10
        case .skeleton:
            texture = SKTexture(imageNamed:"skeletonDownWalk1")
            self.life = 5
        case .mushroom1:
            texture = SKTexture(imageNamed:"mushroom1DownWalk1")
            self.life = 5
        case .ogre:
            texture = SKTexture(imageNamed:"ogreDownWalk1")
            self.life = 20
        }
        hitbox = texture.size().width
        super.init(texture: texture, color: UIColor.gray, size: texture.size())

        self.physicsBody = SKPhysicsBody(circleOfRadius: hitbox)
        self.zPosition = 2
        self.name = "ENEMY"
        self.physicsBody?.affectedByGravity = false
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.applyEffects()
        },SKAction.wait(forDuration: 1)])))
        
        switch type {
        case .hiddenMole:
            self.runningSpeed = 15
            self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "hiddenMoleAnim1"),SKTexture(imageNamed: "hiddenMoleAnim2"),SKTexture(imageNamed: "hiddenMoleAnim3"),SKTexture(imageNamed: "hiddenMoleAnim4")], timePerFrame: 0.1)))
            self.physicsBody?.categoryBitMask = undergroundBitmask
            self.physicsBody?.collisionBitMask = undergroundBitmask
            self.physicsBody?.contactTestBitMask = 0
        case .mole:
            self.physicsBody?.categoryBitMask = enemyBitmask
            self.physicsBody?.collisionBitMask = enemyBitmask
            self.physicsBody?.contactTestBitMask = arrowBitmask
            self.runningSpeed = 100
        case .treant:
            self.physicsBody?.categoryBitMask = enemyBitmask
            self.physicsBody?.collisionBitMask = enemyBitmask
            self.physicsBody?.contactTestBitMask = arrowBitmask
            self.runningSpeed = 45
        case .whiteTreant:
            self.physicsBody?.categoryBitMask = enemyBitmask
            self.physicsBody?.collisionBitMask = enemyBitmask
            self.physicsBody?.contactTestBitMask = arrowBitmask
            self.runningSpeed = 45
        case .skeleton:
            self.physicsBody?.categoryBitMask = enemyBitmask
            self.physicsBody?.collisionBitMask = enemyBitmask
            self.physicsBody?.contactTestBitMask = arrowBitmask
            self.runningSpeed = 100
        case .mushroom1:
            self.physicsBody?.categoryBitMask = enemyBitmask
            self.physicsBody?.collisionBitMask = enemyBitmask
            self.physicsBody?.contactTestBitMask = arrowBitmask
            self.runningSpeed = 50
        case .ogre:
            self.physicsBody?.categoryBitMask = enemyBitmask
            self.physicsBody?.collisionBitMask = enemyBitmask
            self.physicsBody?.contactTestBitMask = arrowBitmask
            self.runningSpeed = 25
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MOVEMENT
    
    
    
    func runAndSetDirection(from: CGPoint, to: CGPoint) {
        let xCoordinate: CGFloat = to.x - from.x
        let yCoordinate: CGFloat = to.y - from.y
        let distance = sqrt(xCoordinate*xCoordinate + yCoordinate*yCoordinate)
        guard let scene = self.scene as? GameScene else {return}
        if self.type == .hiddenMole {
            if distance <= scene.size.width/3 {
                scene.playAnimation(animation: "ground", position: self.position)
                scene.spawnAnEnemy(position: self.position, enemyType: .mole )
                self.removeFromParent()
            }
            self.run(SKAction.move(to: to, duration: TimeInterval(distance/runningSpeed)),withKey: "RUN")
        } else {
            if abs(xCoordinate) >= abs(yCoordinate) {
                direction = xCoordinate >= 0 ? .right : .left
                self.run(SKAction.moveBy(x: xCoordinate, y: 0, duration: TimeInterval(distance/runningSpeed)),withKey: "RUN")
            } else {
                direction = yCoordinate >= 0 ? .up : .down
                self.run(SKAction.moveBy(x: 0, y: yCoordinate, duration: TimeInterval(distance/runningSpeed)),withKey: "RUN")
            }
        }
    }
    
    
    
    // MARK: - SPRITES
    
    func setSprite(_ direction: Direction) {
        self.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "\(type)" + "\(direction)".capitalized + "Walk1"),SKTexture(imageNamed: "\(type)" + "\(direction)".capitalized + "Walk2"),SKTexture(imageNamed: "\(type)" + "\(direction)".capitalized + "Walk3"),SKTexture(imageNamed: "\(type)" + "\(direction)".capitalized + "Walk4")], timePerFrame: 0.2)))
        
        guard let scene = self.scene as? GameScene else {return}
        self.size = scene.setRealSize(width: SKTexture(imageNamed: "\(type)" + "\(direction)".capitalized + "Walk1").size().width, height: SKTexture(imageNamed: "\(type)" + "\(direction)".capitalized + "Walk1").size().height)
    }
    
    
    // MARK: - LOOT
    
    func setAPowerUp() -> PowerUp {
        let randomPowerUp = [PowerUp.PowerUpType.sword,PowerUp.PowerUpType.boots,PowerUp.PowerUpType.gatling,PowerUp.PowerUpType.trishot,PowerUp.PowerUpType.ruby].randomElement()
        let powerUp = PowerUp(randomPowerUp!)
        powerUp.position=self.position
        return powerUp
    }
    
    func dropACoin() -> PowerUp {
        let powerUp = PowerUp(.coin)
        powerUp.position=self.position
        return powerUp
    }
    
    func applyEffects() {
        switch self.state {
        case .none:
            return
        case .fire:
            self.life -= Item.damage/3
            self.run(SKAction.sequence([SKAction.colorize(with: .orange, colorBlendFactor: 0.7, duration: 0.10),SKAction.wait(forDuration: 0.1),SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)]))
            if self.life <= 0 {
                self.died()
            }
        case .poison:
            self.life -= Item.damage/6
            self.run(SKAction.sequence([SKAction.colorize(with: .green, colorBlendFactor: 0.7, duration: 0.10),SKAction.wait(forDuration: 0.1),SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)]))
            if self.life <= 0 {
                self.died()
            }
        }
    }
    
    func died() {
        guard let scene = self.scene as? GameScene else {return}
        if scene.rand(percentage: 10) {
            
            let enemyPowerUp = self.setAPowerUp()
            enemyPowerUp.size = scene.setRealSize(width: enemyPowerUp.size.width, height: enemyPowerUp.size.height)
            enemyPowerUp.size = scene.multiplySize(size: enemyPowerUp.size, multiplier: 1.5)
            scene.addChild(enemyPowerUp)
        } else if scene.rand(percentage: 20) {
            let enemyPowerUp = self.dropACoin()
            enemyPowerUp.size = scene.setRealSize(width: enemyPowerUp.size.width, height: enemyPowerUp.size.height)
            self.addChild(enemyPowerUp)
        }
        scene.playAnimation(animation: "death", position: self.position)
        self.removeFromParent()
    }
    
}
