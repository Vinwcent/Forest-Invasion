//
//  GameCollisions.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 13/05/2021.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    
    // MARK: - FUNCS
    
    func enemyAndProjectileCollision(enemy: Enemy, projectile: SKSpriteNode) {
        if let projectile = projectile as? Projectile? {
            enemy.life -= projectile!.damage
        } else {
            enemy.life -= Item.damage
        }
        if enemy.life <= 0 {
            enemy.died()
        } else {
            if Item.electricArrow && rand(percentage: 20){
                let oldRunningSpeed = enemy.runningSpeed
                enemy.run(SKAction.sequence([SKAction.run {
                    enemy.runningSpeed = 0
                    enemy.removeAction(forKey: "RUN")
                    enemy.run(SKAction.sequence([SKAction.colorize(with: .black, colorBlendFactor: 0.7, duration: 0.3),SKAction.wait(forDuration: 0.4),SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.3)]))
                }, SKAction.wait(forDuration: 1), SKAction.run {
                    enemy.runningSpeed = oldRunningSpeed
                }]))
            } else if Item.poisonedArrow && rand(percentage: 20) {
                enemy.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 0.7, duration: 0.10),SKAction.wait(forDuration: 0.1),SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)]))
                enemy.run(SKAction.sequence([SKAction.run {
                    enemy.state = .poison
                }, SKAction.wait(forDuration: 3), SKAction.run {
                    enemy.state = .none
                }]))
            } else if Item.fearArrow && rand(percentage: 20) {
                enemy.run(SKAction.sequence([SKAction.run {
                    enemy.feared = true
                    enemy.runningSpeed += 50
                    enemy.removeAction(forKey: "RUN")
                    enemy.run(SKAction.sequence([SKAction.colorize(with: .cyan, colorBlendFactor: 0.7, duration: 0.1),SKAction.wait(forDuration: 0.1),SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)]))
                }, SKAction.wait(forDuration: 5), SKAction.run {
                    enemy.feared = false
                    enemy.runningSpeed -= 50
                }]))
            } else if Item.fireArrow && rand(percentage: 20) {
                enemy.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 0.7, duration: 0.10),SKAction.wait(forDuration: 0.1),SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)]))
                enemy.run(SKAction.sequence([SKAction.run {
                    enemy.state = .fire
                }, SKAction.wait(forDuration: 3), SKAction.run {
                    enemy.state = .none
                }]))
            } else if Item.allyArrow && rand(percentage: 20) {
                enemy.run(SKAction.sequence([SKAction.run {
                    enemy.physicsBody?.categoryBitMask = self.arrowBitmask
                    enemy.runningSpeed += 50
                    enemy.removeAction(forKey: "RUN")
                    enemy.run(SKAction.sequence([SKAction.colorize(with: .magenta, colorBlendFactor: 0.7, duration: 0.1),SKAction.wait(forDuration: 5),SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)]))
                }, SKAction.wait(forDuration: 5), SKAction.run {
                    enemy.physicsBody?.categoryBitMask = self.enemyBitmask
                    enemy.runningSpeed -= 50
                }]))
            } else {
                enemy.run(SKAction.sequence([SKAction.colorize(with: .red, colorBlendFactor: 0.7, duration: 0.10),SKAction.wait(forDuration: 0.1),SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.1)]))
            }
            
        }
        
        guard let projectile = projectile as? Projectile? else {return}
        
        if Item.shrapnel && projectile?.projectileType != .shrapnel {
            self.fireOneTime(type: .shrapnel, position: projectile!.position, firingDirection: projectile!.firingDirection, fireType: .trishot)
            projectile!.removeFromParent()
        }
        
        if projectile!.durability == 0 {
            projectile!.removeFromParent()
        } else {
            projectile!.durability -= 1
        }
    }
    
    func enemyAndPlayerCollision(player: Hero, enemy: Enemy) {
        if player.tornado {
            self.playAnimation(animation: "death", position: enemy.position)
            enemy.removeFromParent()
        } else if player.immortal {
            return
        } else {
            Hero.lives -= 1
            if Hero.lives > 0 {
                self.run(SKAction.sequence([SKAction.run {
                    player.immortal = true
                    player.alpha = 0.5
                }, SKAction.wait(forDuration: 1), SKAction.run {
                    player.immortal = false
                    player.alpha = 1
                }]))
            } else {
                self.endGame()
                self.removeAllActions()
                self.removeAllChildren()
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    func activatePowerUp(powerUp: PowerUp) {
        let powerUpTime = powerUp.giveBonus(player: self.player!)
        if powerUp.powerUp == .trishot {
            self.removeAction(forKey:"\(powerUp.powerUp)")
        } else if (self.player?.isFiring)! {
            restartFiring(player: player)
        }
        powerUp.removeFromParent()
        
        
        // Wait the time before removing bonus and restart firing if firing
        if powerUp.powerUp == .trishot {
            self.run(SKAction.sequence([SKAction.wait(forDuration: powerUpTime),SKAction.run {
                powerUp.removeBonus(player: self.player!)
                if (self.player?.isFiring)! {
                    self.restartFiring(player: self.player)
                }
            }]), withKey:"\(powerUp.powerUp)")
        } else {
            self.run(SKAction.sequence([SKAction.wait(forDuration: powerUpTime),SKAction.run {
                powerUp.removeBonus(player: self.player!)
                if (self.player?.isFiring)! {
                    self.restartFiring(player: self.player)
                }
            }]))
        }
    }
    
    func triggerNextStage(spriteName: String) {
        var direction: Map.Direction = .up
        if spriteName == "UP" {
            direction = .up
        } else if spriteName == "RIGHT" {
            direction = .right
        } else if spriteName == "DOWN" {
            direction = .down
        } else if spriteName == "LEFT" {
            direction = .left
        }
        
        let transition = SKTransition.fade(withDuration: 1)
        let transitionScene = SKScene(fileNamed: "TransitionScene") as! TransitionScene
        transitionScene.scaleMode = .resizeFill
        transitionScene.navigationController = self.navigationController
        map?.removeFromParent()
        transitionScene.map = self.map
        transitionScene.directionToGo = direction
        self.view?.presentScene(transitionScene, transition: transition)
        
    }
    
    
    // MARK: - COLLISIONS
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var powerUpNode:SKNode?
        var enemyNode:SKNode?
        var arrowNode:SKNode?
        var itemNode:SKNode?
        var playerNode:SKNode?
        var eventNode:SKNode?
        
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == arrowBitmask | enemyBitmask {
            if contact.bodyA.categoryBitMask == arrowBitmask {
                enemyNode = contact.bodyB.node
                arrowNode = contact.bodyA.node
            } else {
                enemyNode = contact.bodyA.node
                arrowNode = contact.bodyB.node
            }
            if let enemy = enemyNode as! Enemy? {
                guard let arrow = arrowNode as! SKSpriteNode? else {return}
                enemyAndProjectileCollision(enemy: enemy, projectile: arrow)
            }
        
        } else if collision == playerBitmask | enemyBitmask {
            if contact.bodyA.categoryBitMask == playerBitmask {
                enemyNode = contact.bodyB.node
                playerNode = contact.bodyA.node
            } else {
                enemyNode = contact.bodyA.node
                playerNode = contact.bodyB.node
            }
            if let enemy = enemyNode as! Enemy? {
                guard let player = playerNode as! Hero? else {return}
                enemyAndPlayerCollision(player: player, enemy: enemy)
            }
            
            
        } else if collision == playerBitmask | powerUpBitmask {
            if contact.bodyA.categoryBitMask == playerBitmask {
                powerUpNode = contact.bodyB.node
            } else {
                powerUpNode = contact.bodyA.node
            }
            if let powerUp = powerUpNode as! PowerUp? {
                
                if (player?.hasPowerUp)! || powerUp.powerUp == .coin || powerUp.powerUp == .ruby {
                    activatePowerUp(powerUp: powerUp)
                } else {
                    setupSavedPowerUp(powerUp: powerUp)
                    
                }
            }
        } else if collision == playerBitmask | eventBitmask {
            if contact.bodyA.categoryBitMask == playerBitmask {
                eventNode = contact.bodyB.node
            } else {
                eventNode = contact.bodyA.node
            }
            if let eventSpriteNode = eventNode as! SKSpriteNode? {
                triggerNextStage(spriteName: eventSpriteNode.name!)
            }
        } else if collision == playerBitmask | itemBitmask {
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
}
