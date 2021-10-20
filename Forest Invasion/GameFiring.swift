//
//  GameFiring.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 13/05/2021.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    func createAProjectile(type: Projectile.ProjectileType ,position: CGPoint, firingDirection: Hero.FiringDirection) -> Projectile {
        let angle:CGFloat
        switch firingDirection {
        case .right:
            angle = 0
        case .upRight:
            angle = CGFloat.pi/4
        case .up:
            angle = CGFloat.pi/2
        case .upLeft:
            angle = 3*CGFloat.pi/4
        case .left:
            angle = CGFloat.pi
        case .downLeft:
            angle = -3*CGFloat.pi/4
        case .down:
            angle = -CGFloat.pi/2
        case .downRight:
            angle = -CGFloat.pi/4
        }
        let projectile = Projectile(type: type, celerity: Item.projectileCelerity, angle: angle, hitbox: 4*self.size.width/512, firingDirection: firingDirection)
        projectile.position = position
        projectile.size = self.setRealSize(width: projectile.projectileSize*(projectile.texture?.size().width)! , height: projectile.projectileSize*(projectile.texture?.size().height)!)
        if type == .fireball {
            projectile.size = multiplySize(size: projectile.size, multiplier: 0.7)
        }
        self.addChild(projectile)
        return projectile
    }
    
    func fireOneTime(type: Projectile.ProjectileType, position: CGPoint, firingDirection: Hero.FiringDirection,fireType: Hero.FireType) {
        let firingDirection = firingDirection
        switch fireType {
        case .classic:
            let arrow = createAProjectile(type: type, position: position, firingDirection: firingDirection)
            switch firingDirection {
            case .up:
                arrow.physicsBody?.velocity = CGVector(dx: 0, dy: arrow.celerity)
            case .upRight:
                arrow.physicsBody?.velocity = CGVector(dx: arrow.celerity/sqrt(2), dy: arrow.celerity/sqrt(2))
            case .upLeft:
                arrow.physicsBody?.velocity = CGVector(dx: -arrow.celerity/sqrt(2), dy: arrow.celerity/sqrt(2))
            case .right:
                arrow.physicsBody?.velocity = CGVector(dx: arrow.celerity, dy: 0)
            case .down:
                arrow.physicsBody?.velocity = CGVector(dx: 0, dy: -arrow.celerity)
            case .downRight:
                arrow.physicsBody?.velocity = CGVector(dx: arrow.celerity/sqrt(2), dy: -arrow.celerity/sqrt(2))
            case .downLeft:
                arrow.physicsBody?.velocity = CGVector(dx: -arrow.celerity/sqrt(2), dy: -arrow.celerity/sqrt(2))
            case .left:
                arrow.physicsBody?.velocity = CGVector(dx: -arrow.celerity, dy: 0)
            }
            if type != .grenade {
                self.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run {
                    arrow.removeFromParent()
                }])) // Autodestruction of the arrow
            }
        case .trishot:
            let projectile1 = createAProjectile(type: type, position: position, firingDirection: firingDirection)
            let projectile2 = createAProjectile(type: type, position: position, firingDirection: firingDirection)
            let projectile3 = createAProjectile(type: type,position: position, firingDirection: firingDirection)
            switch firingDirection {
            case .up:
                projectile1.physicsBody?.velocity = CGVector(dx: 0, dy: projectile1.celerity)
                projectile2.physicsBody?.velocity = CGVector(dx: -projectile2.celerity*sin(CGFloat.pi/8), dy: projectile2.celerity*cos(CGFloat.pi/8))
                projectile3.physicsBody?.velocity = CGVector(dx: projectile3.celerity*sin(CGFloat.pi/8), dy: projectile3.celerity*cos(CGFloat.pi/8))
                
            case .upRight:
                projectile1.physicsBody?.velocity = CGVector(dx: projectile1.celerity/sqrt(2), dy: projectile1.celerity/sqrt(2))
                projectile2.physicsBody?.velocity = CGVector(dx: projectile2.celerity*sin(CGFloat.pi/8), dy: projectile2.celerity*cos(CGFloat.pi/8))
                projectile3.physicsBody?.velocity = CGVector(dx: projectile3.celerity*cos(CGFloat.pi/8), dy: projectile3.celerity*sin(CGFloat.pi/8))
                
            case .upLeft:
                projectile1.physicsBody?.velocity = CGVector(dx: -projectile1.celerity/sqrt(2), dy: projectile1.celerity/sqrt(2))
                projectile2.physicsBody?.velocity = CGVector(dx: -projectile2.celerity*sin(CGFloat.pi/8), dy: projectile2.celerity*cos(CGFloat.pi/8))
                projectile3.physicsBody?.velocity = CGVector(dx: -projectile3.celerity*cos(CGFloat.pi/8), dy: projectile3.celerity*sin(CGFloat.pi/8))
            case .right:
                projectile1.physicsBody?.velocity = CGVector(dx: projectile1.celerity, dy: 0)
                projectile2.physicsBody?.velocity = CGVector(dx: projectile2.celerity*cos(CGFloat.pi/8), dy: projectile2.celerity*sin(CGFloat.pi/8))
                projectile3.physicsBody?.velocity = CGVector(dx: projectile3.celerity*cos(CGFloat.pi/8), dy: -projectile3.celerity*sin(CGFloat.pi/8))
            case .down:
                projectile1.physicsBody?.velocity = CGVector(dx: 0, dy: -projectile1.celerity)
                projectile2.physicsBody?.velocity = CGVector(dx: -projectile2.celerity*sin(CGFloat.pi/8), dy: -projectile2.celerity*cos(CGFloat.pi/8))
                projectile3.physicsBody?.velocity = CGVector(dx: projectile3.celerity*sin(CGFloat.pi/8), dy: -projectile3.celerity*cos(CGFloat.pi/8))
            case .downRight:
                projectile1.physicsBody?.velocity = CGVector(dx: projectile1.celerity/sqrt(2), dy: -projectile1.celerity/sqrt(2))
                projectile2.physicsBody?.velocity = CGVector(dx: projectile2.celerity*sin(CGFloat.pi/8), dy: -projectile2.celerity*cos(CGFloat.pi/8))
                projectile3.physicsBody?.velocity = CGVector(dx: projectile3.celerity*cos(CGFloat.pi/8), dy: -projectile3.celerity*sin(CGFloat.pi/8))
            case .downLeft:
                projectile1.physicsBody?.velocity = CGVector(dx: -projectile1.celerity/sqrt(2), dy: -projectile1.celerity/sqrt(2))
                projectile2.physicsBody?.velocity = CGVector(dx: -projectile2.celerity*sin(CGFloat.pi/8), dy: -projectile2.celerity*cos(CGFloat.pi/8))
                projectile3.physicsBody?.velocity = CGVector(dx: -projectile3.celerity*cos(CGFloat.pi/8), dy: -projectile3.celerity*sin(CGFloat.pi/8))
            case .left:
                projectile1.physicsBody?.velocity = CGVector(dx: -projectile1.celerity, dy: 0)
                projectile2.physicsBody?.velocity = CGVector(dx: -projectile2.celerity*cos(CGFloat.pi/8), dy: projectile2.celerity*sin(CGFloat.pi/8))
                projectile3.physicsBody?.velocity = CGVector(dx: -projectile3.celerity*cos(CGFloat.pi/8), dy: -projectile3.celerity*sin(CGFloat.pi/8))
            }
            self.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run {
                projectile1.removeFromParent()
                projectile2.removeFromParent()
                projectile3.removeFromParent()
            }])) // Autodestruction of the arrows
        }
        
    }
    
    func startFiring(player: Hero?) {
        
        guard let player = self.player else {return}
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: Item.firingSpeed),SKAction.run {
            self.fireOneTime(type: .arrow,position: player.position,firingDirection: player.firingDirection ,fireType: player.fireType)
            self.triggerFireball()
            self.triggerGrenade()
        }])), withKey: "Firing")
        player.isFiring = true
        
    }
    
    func stopFiring(player: Hero?) {
        self.removeAction(forKey: "Firing")
        player?.isFiring = false
    }
    
    func restartFiring(player: Hero?) {
        stopFiring(player: player)
        startFiring(player: player)
    }
    
    func triggerFireball() {
        if Item.fireball && rand(percentage: 5) {
            guard let player = self.player else {return}
            self.fireOneTime(type: .fireball, position: player.position, firingDirection: .up, fireType: .classic)
            self.fireOneTime(type: .fireball, position: player.position, firingDirection: .right, fireType: .classic)
            self.fireOneTime(type: .fireball, position: player.position, firingDirection: .down, fireType: .classic)
            self.fireOneTime(type: .fireball, position: player.position, firingDirection: .left, fireType: .classic)
        }
    }
    
    func triggerGrenade() {
        if Item.grenade && rand(percentage: 5) {
            guard let player = self.player else {return}
            var firstGrenadeDirection: Hero.FiringDirection
            var secondGrenadeDirection: Hero.FiringDirection
            switch player.direction {
            case .up:
                firstGrenadeDirection = .upLeft
                secondGrenadeDirection = .upRight
            case .down:
                firstGrenadeDirection = .downLeft
                secondGrenadeDirection = .downRight
            case .right:
                firstGrenadeDirection = .upRight
                secondGrenadeDirection = .downRight
            case .left:
                firstGrenadeDirection = .upLeft
                secondGrenadeDirection = .downLeft
            }
            self.fireOneTime(type: .grenade, position: player.position, firingDirection: firstGrenadeDirection, fireType: .classic)
            self.fireOneTime(type: .grenade, position: player.position, firingDirection: secondGrenadeDirection, fireType: .classic)
        }
    }

}
