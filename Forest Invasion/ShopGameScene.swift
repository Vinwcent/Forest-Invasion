//
//  ShopGameScene.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 16/05/2021.
//

import SpriteKit
import GameplayKit

class ShopGameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    // MARK: - VAR/CONS
    
    var player:Hero?
    var topHud:SKSpriteNode?
    var downHud:SKSpriteNode?
    var amountOfCoinsLabel:SKLabelNode?
    var amountOfLivesLabel:SKLabelNode?
    var stageLabel:SKLabelNode?
    var stage:Stage?
    var amountOfEmeraldsLabel:SKLabelNode?
    var navigationController: UINavigationController?
    var map: Map?
    
    
    
    
    let enemyBitmask:UInt32 = 0x1 << 0
    let playerBitmask:UInt32 = 0x1 << 1
    let arrowBitmask:UInt32 = 0x1 << 2
    let environmentBitmask:UInt32 = 0x1 << 3
    let powerUpBitmask:UInt32 = 0x1 << 4
    let itemBitmask:UInt32 = 0x1 << 5
    
    // MARK: FUNCS
    
    func setPlayer() {
        player = Hero(image: "heroDown")
        let playerPosition = CGPoint(x: self.size.width/2, y: self.size.height/2)
        player?.position=playerPosition
        Item.walkingSpeed = self.size.width/6
        self.addChild(player!)
    }
    
    func setupTopHud() {
        topHud = SKSpriteNode(imageNamed: "brown")
        let topHudWidth = CGFloat(self.size.width)
        let topHudHeight = CGFloat(self.size.height/10)
        let topHudPosition = CGPoint(x: self.size.width/2, y: 9.5*self.size.height/10)
        topHud?.scale(to: CGSize(width: topHudWidth, height: topHudHeight))
        topHud?.position = topHudPosition
        topHud?.zPosition = 4
        self.addChild(topHud!)
        
        
        amountOfCoinsLabel = SKLabelNode(fontNamed: "Noteworthy")
        amountOfCoinsLabel?.fontSize = 20
        let amountOfCoinsLabelPosition = CGPoint(x: self.size.width/5, y: 9.25*self.size.height/10)
        amountOfCoinsLabel?.position = amountOfCoinsLabelPosition
        amountOfCoinsLabel?.zPosition = 5
        amountOfCoinsLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(amountOfCoinsLabel!)
        
        let coinIcon = SKSpriteNode(imageNamed: "coin1")
        coinIcon.size = setRealSize(width: 10, height: 14)
        coinIcon.position.x -= 30
        coinIcon.zPosition = 5
        amountOfCoinsLabel?.addChild(coinIcon)
        
        
        amountOfLivesLabel = SKLabelNode(fontNamed: "Noteworthy")
        amountOfLivesLabel?.fontSize = 20
        let amountOfLivesLabelPosition = CGPoint(x: 2*self.size.width/5, y: 9.25*self.size.height/10)
        amountOfLivesLabel?.position = amountOfLivesLabelPosition
        amountOfLivesLabel?.zPosition = 5
        amountOfLivesLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(amountOfLivesLabel!)
        
        let lifeIcon = SKSpriteNode(imageNamed: "life")
        lifeIcon.position.x -= 30
        lifeIcon.zPosition = 5
        amountOfLivesLabel?.addChild(lifeIcon)
        
        
        stageLabel = SKLabelNode(fontNamed: "Noteworthy")
        stageLabel?.fontSize = 20
        let stageLabelPosition = CGPoint(x: 3*self.size.width/5, y: 9.25*self.size.height/10)
        stageLabel?.position = stageLabelPosition
        stageLabel?.zPosition = 5
        stageLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(stageLabel!)
        
        let stageIcon = SKSpriteNode(imageNamed: "paw")
        stageIcon.position.x -= 30
        stageIcon.zPosition = 5
        stageLabel?.addChild(stageIcon)
        
        
        amountOfEmeraldsLabel = SKLabelNode(fontNamed: "Noteworthy")
        amountOfEmeraldsLabel?.fontSize = 20
        let amountOfEmeraldsLabelPosition = CGPoint(x: 4*self.size.width/5, y: 9.25*self.size.height/10)
        amountOfEmeraldsLabel?.position = amountOfEmeraldsLabelPosition
        amountOfEmeraldsLabel?.zPosition = 5
        amountOfEmeraldsLabel?.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(amountOfEmeraldsLabel!)
        
        let emeraldIcon = SKSpriteNode(imageNamed: "emerald")
        emeraldIcon.position.x -= 30
        emeraldIcon.zPosition = 5
        amountOfEmeraldsLabel?.addChild(emeraldIcon)
    }
    
    func setupDownHud() {
        downHud = SKSpriteNode(imageNamed: "downHud")
        let downHudWidth = CGFloat(self.size.width)
        let downHudHeight = CGFloat(2*self.size.height/10)
        let downHudPosition = CGPoint(x: self.size.width/2, y: self.size.height/10)
        downHud?.scale(to: CGSize(width: downHudWidth, height: downHudHeight))
        downHud?.position = downHudPosition
        downHud?.zPosition = 4
        self.addChild(downHud!)
    }
    
    func setupGameHud() {
        let gameBackground=SKSpriteNode(imageNamed: "shop")
        let gameWidth = CGFloat(self.size.width)
        let gameHeight = CGFloat(7*self.size.height/10)
        let gamePosition = CGPoint(x: self.size.width/2, y: 5.5*self.size.height/10)
        
        
        gameBackground.scale(to: CGSize(width: gameWidth, height: gameHeight))
        gameBackground.position=gamePosition
        gameBackground.zPosition = 0
        self.addChild(gameBackground)
        
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 2*self.size.height/10, width: gameWidth, height: gameHeight ))
        self.physicsBody?.categoryBitMask = environmentBitmask
        
    }
    
    func initalizeMenu() {
        setupTopHud()
        setupDownHud()
        setupGameHud()
    }
    
    func setStageLevel() {
        stage = Stage(stage: Stage.currentStage)
    }
    
    func initializeGame() {
        initalizeMenu()
        setPlayer()
        setupJoystick()
        setStageLevel()
    }
    
    func goBackToGame() {
        let transition = SKTransition.fade(withDuration: 1)
        let transitionScene = SKScene(fileNamed: "TransitionScene") as! TransitionScene
        Stage.currentStage += 1
        transitionScene.navigationController = self.navigationController
        transitionScene.scaleMode = .resizeFill
        self.view?.presentScene(transitionScene, transition: transition)
    }
    
    
    
    //MARK: COLLISION
    
    func didBegin(_ contact: SKPhysicsContact) {
            
        var itemNode:SKNode?
        
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == playerBitmask | itemBitmask {
            if contact.bodyA.categoryBitMask == playerBitmask {
                itemNode = contact.bodyB.node
            } else {
                itemNode = contact.bodyA.node
            }
            if let item = itemNode as! Item? {
                if Hero.amountOfCoins >= item.price {
                    item.giveStats()
                    Hero.amountOfCoins -= item.price
                    item.removeFromParent()
                }
            }
        }
            
    }
    
    
    //MARK: JOYSTICK
    
    lazy var analogMoveJoystick: AnalogJoystick = {
        let joystick = AnalogJoystick(diameter: 120, colors: nil, images: (substrate: UIImage(named: "jSubstrate"), stick: UIImage(named: "jStick")))
        joystick.position = CGPoint(x: self.size.width/2, y: self.size.height/10)
        return joystick
    }()
    
    func setupJoystick() {
        analogMoveJoystick.zPosition=5
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
    
    override func didMove(to view: SKView) {
        initializeGame()
        setupTheSeller()
        setupTheItems()
        
        self.run(SKAction.sequence([SKAction.wait(forDuration: 15),SKAction.run {
            self.goBackToGame()
        }]))
    }
    
    // MARK: UPDATE
    
    override func update(_ currentTime: TimeInterval) {
        
        amountOfCoinsLabel?.text = "\(Hero.amountOfCoins)"
        amountOfLivesLabel?.text = "\(Hero.lives)"
        stageLabel?.text = "\(Int((self.stage?.stageNumber)!))"
        amountOfEmeraldsLabel?.text = "\(GameHandler.sharedInstance.amountOfEmeralds)"
        
        guard let player = self.player else {return}
        
        player.size = self.setRealSize(width: (player.texture?.size().width)! , height: (player.texture?.size().height)!)
    }
    
}
