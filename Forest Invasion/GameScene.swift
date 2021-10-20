//
//  GameScene.swift
//  Invasion
//
//  Created by Vincent Van Wynendaele on 07/05/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - WORKPLACE
    
    var hackBool: Bool = true
    
    func cheat() {
        Item.firingSpeed = 0.1
        Item.shrapnel = true
        Item.arrowDurability = 1
        Item.projectileSize = 4
        Stage.currentStage = 3
    }
    
    
    
    
    // MARK: - VAR/CONS

    var player:Hero?
    var topHud:SKSpriteNode?
    var downHud:SKSpriteNode?
    var amountOfCoinsLabel:SKLabelNode?
    var amountOfLivesLabel:SKLabelNode?
    var stageLabel:SKLabelNode?
    var stage:Stage?
    var amountOfEmeraldsLabel:SKLabelNode?
    var isGoingNextStage = false
    var navigationController: UINavigationController?
    var map: Map?
    
    static var savedPowerUp: PowerUp?
    
    
    
    let enemyBitmask:UInt32 = 0x1 << 0
    let playerBitmask:UInt32 = 0x1 << 1
    let arrowBitmask:UInt32 = 0x1 << 2
    let environmentBitmask:UInt32 = 0x1 << 3
    let powerUpBitmask:UInt32 = 0x1 << 4
    let itemBitmask:UInt32 = 0x1 << 5
    let undergroundBitmask:UInt32 = 0x1 << 6
    let eventBitmask:UInt32 = 0x1 << 7
    
    // MARK: INITIALIZING
    
    func setPlayer() {
        player = Hero(image: "heroDown")
        let playerPosition = CGPoint(x: self.size.width/2, y: 5.5*self.size.height/10)
        player?.position=playerPosition
        Item.walkingSpeed = self.size.width/6
        self.addChild(player!)
        player?.direction = .down
    }
    
    func initializeMenu() {
        setupTopHud()
        setupGameEnvironment(tileType: (map?.actualTileType)!)
        setupDownHud()
    }
    
    func setStage() {
        stage = Stage(stage: Stage.currentStage)
    }
    
    func setupSavedPowerUp(powerUp: PowerUp?) {
        GameScene.savedPowerUp = powerUp
        powerUp?.removeFromParent()
        guard let unwrappedPowerUp = powerUp else {return}
        player?.hasPowerUp = true
        unwrappedPowerUp.zPosition = 7
        unwrappedPowerUp.position = CGPoint(x: self.size.width/2, y: 2*self.size.height/10)
        self.addChild(unwrappedPowerUp)
    }
    
    func setTheMap() {
        map?.position = CGPoint(x: -1.5*self.size.width/10, y: 9*self.size.height/10-2*self.size.width/10)
        map?.size = CGSize(width: 4*self.size.width/10, height: 4*self.size.width/10)
        map?.zPosition = 7
        map?.isShowed = false
        self.addChild(map!)
    }
    
    func initializeGame() {
        initializeMenu()
        setPlayer()
        setupJoysticks()
        setTheMap()
        setupSavedPowerUp(powerUp: GameScene.savedPowerUp)
        setStage()
        startSpawning()
    }
    
    // MARK: - END
    
    
    func goNext() {
        let bodyRight = SKPhysicsBody(rectangleOf: CGSize(width: 16, height: 7*self.size.height/10), center: CGPoint(x: self.size.width, y: 5.5*self.size.width/10))
        let bodyDown = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 16), center: CGPoint(x: self.size.width/2, y: 2*self.size.height/10))
        let bodyLeft = SKPhysicsBody(rectangleOf: CGSize(width: 16, height: 7*self.size.height/10), center: CGPoint(x: 0, y: 5.5*self.size.width/10))
        let bodyUp = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 16), center: CGPoint(x: self.size.width/2, y: 9*self.size.height/10))
        
        let triggerDown = SKSpriteNode(color: UIColor.white, size: CGSize(width: 0, height: 0))
        triggerDown.zPosition = 1
        triggerDown.name = "DOWN"
        triggerDown.physicsBody = bodyDown
        triggerDown.physicsBody?.isDynamic = false
        triggerDown.physicsBody?.categoryBitMask = eventBitmask
        triggerDown.physicsBody?.collisionBitMask = 0
        triggerDown.physicsBody?.contactTestBitMask = playerBitmask
        if map?.actualPosition[0] != 3 {
            self.addChild(triggerDown)
        }
        let triggerLeft = SKSpriteNode(color: UIColor.white, size: CGSize(width: 0, height: 0))
        triggerLeft.zPosition = 1
        triggerLeft.name = "LEFT"
        triggerLeft.physicsBody = bodyLeft
        triggerLeft.physicsBody?.isDynamic = false
        triggerLeft.physicsBody?.categoryBitMask = eventBitmask
        triggerLeft.physicsBody?.collisionBitMask = 0
        triggerLeft.physicsBody?.contactTestBitMask = playerBitmask
        if map?.actualPosition[1] != 0 {
            self.addChild(triggerLeft)
        }
        let triggerUp = SKSpriteNode(color: UIColor.white, size: CGSize(width: 0, height: 0))
        triggerUp.zPosition = 1
        triggerUp.name = "UP"
        triggerUp.physicsBody = bodyUp
        triggerUp.physicsBody?.isDynamic = false
        triggerUp.physicsBody?.categoryBitMask = eventBitmask
        triggerUp.physicsBody?.collisionBitMask = 0
        triggerUp.physicsBody?.contactTestBitMask = playerBitmask
        if map?.actualPosition[0] != 0 {
            self.addChild(triggerUp)
        }
        let triggerRight = SKSpriteNode(color: UIColor.white, size: CGSize(width: 0, height: 0))
        triggerRight.zPosition = 1
        triggerRight.name = "RIGHT"
        triggerRight.physicsBody = bodyRight
        triggerRight.physicsBody?.isDynamic = false
        triggerRight.physicsBody?.categoryBitMask = eventBitmask
        triggerRight.physicsBody?.collisionBitMask = 0
        triggerRight.physicsBody?.contactTestBitMask = playerBitmask
        if map?.actualPosition[1] != 3 {
            self.addChild(triggerRight)
        }
        let flashingSign = SKSpriteNode(imageNamed: "flashingArrow" )
        flashingSign.position = CGPoint(x: 8*self.size.width/10, y: 8.5*self.size.height/10)
        flashingSign.size = CGSize(width:2*(flashingSign.texture?.size().width)!, height: 2*(flashingSign.texture?.size().height)!)
        flashingSign.zPosition = 5
        self.addChild(flashingSign)
        flashingSign.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "flashingArrow"),SKTexture(imageNamed: "empty")], timePerFrame: 0.5)))
    }
    
    func endGame() {
        Stage.currentStage = 1
        Hero.lives = 3
        Hero.amountOfCoins = 0
        Item.reinitializeStats()
        GameScene.savedPowerUp = nil
        GameHandler.sharedInstance.saveGameStats()
    }
    

    // MARK: - JOYSTICKS
    
    
    
            // MARK: - MOVEJOYSTICK
    
    lazy var analogMoveJoystick: AnalogJoystick = {
        let joystick = AnalogJoystick(diameter: 14/100*self.size.height, colors: nil, images: (substrate: UIImage(named: "empty"), stick: UIImage(named: "joyStickWalk")))
        joystick.position = CGPoint(x: self.size.width/4, y: self.size.height/10)
        joystick.alpha = 1
        return joystick
    }()
    
    func setupMoveJoystick() {
        analogMoveJoystick.zPosition=6
        let joystickMap = SKSpriteNode(imageNamed: "joyStickMap")
        joystickMap.zPosition = 5
        joystickMap.position = CGPoint(x: self.size.width/4, y: self.size.height/10)
        joystickMap.size = CGSize(width: 16*self.size.height/100, height: 16*self.size.height/100)
        addChild(joystickMap)
        addChild(analogMoveJoystick)
        
        guard let player = self.player else {return}
        
        analogMoveJoystick.trackingHandler = { [unowned self] data in
            
            
            player.physicsBody?.velocity = CGVector(dx: data.velocity.x*(1+Item.walkingSpeed/100), dy: data.velocity.y*(1+Item.walkingSpeed/100))
            
            if !player.isFiring {
                if abs(data.velocity.x) > abs(data.velocity.y) {
                    if data.velocity.x > 0 {
                        player.direction = .right
                    } else {
                        player.direction = .left
                    }
                } else {
                    if data.velocity.y > 0 {
                        player.direction = .up
                    } else {
                        player.direction = .down
                    }
                }
            }
        }
        
        analogMoveJoystick.beginHandler = {
            player.isWalking = true
        }
        
        analogMoveJoystick.stopHandler = {
            player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            player.isWalking = false
            player.direction = player.walkingDirection
        }
        
    }
    
            // MARK: - FIREJOYSTICK
    
    lazy var analogFireJoystick: AnalogJoystick = {
        let joystick = AnalogJoystick(diameter: 14/100*self.size.height, colors: nil, images: (substrate: UIImage(named: "empty"), stick: UIImage(named: "joyStickFire")))
        joystick.alpha = 1
        joystick.position = CGPoint(x: 3*self.size.width/4, y: self.size.height/10)
        return joystick
    }()
    
    func setupFireJoystick() {
        analogFireJoystick.zPosition=6
        let joystickMap = SKSpriteNode(imageNamed: "joyStickMap")
        joystickMap.zPosition = 5
        joystickMap.position = CGPoint(x: 3*self.size.width/4, y: self.size.height/10)
        joystickMap.size = CGSize(width: 16*self.size.height/100, height: 16*self.size.height/100)
        addChild(joystickMap)
        addChild(analogFireJoystick)
        
        guard let player = self.player else {return}
        
        analogFireJoystick.trackingHandler = { [unowned self] data in
            if data.angular >= -CGFloat.pi/4 && data.angular <= CGFloat.pi/4 {
                player.direction = .up
                if data.angular >= -CGFloat.pi/8 && data.angular <= CGFloat.pi/8 {
                    player.firingDirection = .up
                } else {
                    player.firingDirection = data.angular >= CGFloat.pi/8 ? .upLeft : .upRight
                }
            } else if data.angular >= CGFloat.pi/4 && data.angular <= 3*CGFloat.pi/4 {
                player.direction = .left
                if data.angular >= 3*CGFloat.pi/8 && data.angular <= 5*CGFloat.pi/8 {
                    player.firingDirection = .left
                } else {
                    player.firingDirection = data.angular >= 5*CGFloat.pi/8 ? .downLeft : .upLeft
                }
            } else if data.angular >= -3*CGFloat.pi/4 && data.angular <= -CGFloat.pi/4 {
                player.direction = .right
                if data.angular >= -5*CGFloat.pi/8 && data.angular <= -3*CGFloat.pi/8 {
                    player.firingDirection = .right
                } else {
                    player.firingDirection = data.angular >= -3*CGFloat.pi/8 ? .upRight : .downRight
                }
            } else {
                player.direction = .down
                if data.angular >= 7*CGFloat.pi/8 || data.angular <= -7*CGFloat.pi/8 {
                    player.firingDirection = .down
                } else {
                    player.firingDirection = data.angular >= 0 ? .downLeft : .downRight
                }
            }
        }
        
        analogFireJoystick.beginHandler = {
            self.startFiring(player: player)
        }
        
        analogFireJoystick.stopHandler = {
            self.stopFiring(player: player)
            player.direction = player.walkingDirection
        }
    }
    
    func setupJoysticks() {
        setupMoveJoystick()
        setupFireJoystick()
    }
    
    // MARK: - OVERRIDES
    
    override func didMove(to view: SKView) {
        initializeGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // MARK: - VALUES UPDATE
        
        amountOfCoinsLabel?.text = "\(Hero.amountOfCoins)"
        amountOfLivesLabel?.text = "\(Hero.lives)"
        stageLabel?.text = "\(Int((self.stage?.stageNumber)!))"
        amountOfEmeraldsLabel?.text = "\(GameHandler.sharedInstance.amountOfEmeralds)"
        
        
        // MARK: - CHECK END
        
        guard let stage = self.stage else {return}
        
        if map?.actualTileType == .monster {
            if stage.enemiesSpawned >= stage.amountOfEnemies {
                self.removeAction(forKey: "Spawning")
                if self["ENEMY"].count == 0 && !isGoingNextStage {
                    isGoingNextStage = true
                    self.goNext()
                }
            }
        } else {
            if !isGoingNextStage {
                isGoingNextStage = true
                self.goNext()
            }
        }
        
        // MARK: - ITEMS
        
        if Item.snakeVision {
            guard let player = self.player else {return}
            poisonInFrontOfHero(player: player)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPosition = touch.location(in: self)
            let nodeTouched = self.atPoint(touchPosition)
            if (map?.isShowed)! {
                map?.putAwayTheMap()
            } else if nodeTouched == map {
                map?.pullOutTheMap()
            } else if touchPosition.y >= 2*self.size.height/10 && touchPosition.y <= 9*self.size.height/10 {
                guard let powerUpReady = GameScene.savedPowerUp else {return}
                self.activatePowerUp(powerUp: powerUpReady)
                player?.hasPowerUp = false
                powerUpReady.removeFromParent()
                GameScene.savedPowerUp = nil
            }
        }
    }
    
    
    
    
}
//self.run(SKAction.sequence([SKAction.run {
//    let sign = SKSpriteNode(imageNamed: "endSign")
//    sign.position = CGPoint(x: self.size.width/2, y: 6.66*self.size.height/10)
//    sign.size = self.setRealSize(width: 2*sign.size.width, height: 2*sign.size.height)
//    sign.zPosition = 1
//    self.playAnimation(animation: "smoke", position: sign.position)
//    self.addChild(sign)
//},SKAction.wait(forDuration: 3),SKAction.run {
//    self.nextStage()
//}]))
