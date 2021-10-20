//
//  GameEnemies.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 13/05/2021.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    func giveMeSpawnPoint() -> CGPoint {
        let randomSide=GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        var spawnPoint: CGPoint
        switch randomSide {
        case 0:
            let randomHeightPosition:CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 5))
            spawnPoint = CGPoint(x: (self.size.width), y: (2+randomHeightPosition)*self.size.height/10)
        case 1:
            let randomWidthPosition:CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 10))
            spawnPoint = CGPoint(x: randomWidthPosition*self.size.width/10, y: 9*self.size.height/10)
        case 2:
            let randomWidthPosition:CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 10))
            spawnPoint = CGPoint(x: randomWidthPosition*self.size.width/10, y: 2*self.size.height/10)
        case 3:
            let randomHeightPosition:CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: 5))
            spawnPoint = CGPoint(x: 0, y: (2+randomHeightPosition)*self.size.height/10 )
        default:
            spawnPoint = CGPoint(x: self.size.width, y: 9*self.size.height/10)
        }
        return spawnPoint
    }
    
    func spawnAnEnemy(position: CGPoint, enemyType: Enemy.EnemyType) {
        let enemy = Enemy(type: enemyType)
        var timeBeforeSpawning:TimeInterval
        enemy.position = position
        enemy.size = self.setRealSize(width: enemy.size.width , height: enemy.size.height)
        if enemyType == .mole {
            timeBeforeSpawning = TimeInterval(0)
        } else {
            timeBeforeSpawning = TimeInterval(GKRandomSource.sharedRandom().nextInt(upperBound:2))
            self.stage?.enemiesSpawned += 1
        }
        self.run(SKAction.sequence([SKAction.wait(forDuration: timeBeforeSpawning),SKAction.run {
            self.addChild(enemy)
            
            guard let player = self.player else {return}
            
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
                if enemy.feared {
                    enemy.runAndSetDirection(from: player.position, to: enemy.position)
                } else {
                    enemy.runAndSetDirection(from: enemy.position, to: player.position)
                }
            },SKAction.wait(forDuration: 0.8)])))
        }]))
    }
    
    func spawnABatchOfEnemies() {
        let amountAtTheSameSpot = GKRandomSource.sharedRandom().nextInt(upperBound: 5)
        var spawnPoint = self.giveMeSpawnPoint()
        for i in 0..<amountAtTheSameSpot {
            spawnPoint.x = spawnPoint.x + CGFloat(i)
            let randomEnemy = (self.stage?.enemyPool.randomElement()!)!
            self.spawnAnEnemy(position: spawnPoint, enemyType: randomEnemy)
        }
    }
    
    func startSpawning() {
        if map?.actualTileType == .monster {
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
                self.spawnABatchOfEnemies()
            }, SKAction.wait(forDuration: self.stage!.timeBetweenBatch )])),withKey: "Spawning")
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
        } else if animation == "ground" {
            let texture = SKSpriteNode(imageNamed: "ground1")
            texture.size = self.setRealSize(width: (texture.texture?.size().width)! , height: (texture.texture?.size().height)!)
            texture.position = position
            texture.zPosition = 3
            self.addChild(texture)
            texture.run(SKAction.sequence([SKAction.animate(with: [SKTexture(imageNamed: "ground1"),SKTexture(imageNamed: "ground2"),SKTexture(imageNamed: "ground3"),SKTexture(imageNamed: "ground4"),SKTexture(imageNamed: "ground5"),SKTexture(imageNamed: "ground6"),SKTexture(imageNamed: "ground7"),SKTexture(imageNamed: "ground8"),SKTexture(imageNamed: "ground9"),SKTexture(imageNamed: "ground10")], timePerFrame: 0.05), SKAction.run {
                texture.removeFromParent()
            }]))
        }
    }
}
