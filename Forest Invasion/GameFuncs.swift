//
//  GameSize.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 16/05/2021.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    func setRealSize(width: CGFloat, height: CGFloat) -> CGSize {
        let screenMultiplier = (7*self.size.height/10)/self.size.width
        return CGSize(width: screenMultiplier*width*self.size.width/512, height: height*(7*self.size.height/10)/640)
    }
    
    func multiplySize(size: CGSize, multiplier: CGFloat) -> CGSize {
        let width = size.width*multiplier
        let height = size.height*multiplier
        return CGSize(width: width, height: height)
    }
    
    func rand(percentage: Int) -> Bool {
        let randInt = GKRandomSource.sharedRandom().nextInt(upperBound: 101)
        if randInt <= percentage {
            return true
        } else {
            return false
        }
    }
    
    func poisonInFrontOfHero(player: Hero) {
        self.enumerateChildNodes(withName: "ENEMY") {
            (node:SKNode, nil) in
            guard let enemyNode = node as? Enemy else {return}
            let distance = sqrt(pow((player.position.x-node.position.x),2)+pow((player.position.y-node.position.y),2))
            switch player.direction {
            case .up:
                if node.position.y >= player.position.y && distance <= self.size.height/10 && enemyNode.state != .poison {
                    enemyNode.run(SKAction.sequence([SKAction.run {
                        enemyNode.state = .poison
                    }, SKAction.wait(forDuration: 3), SKAction.run {
                        enemyNode.state = .none
                    }]))
                }
            case .down:
                if node.position.y <= player.position.y && distance <= self.size.height/10 && enemyNode.state != .poison {
                    enemyNode.run(SKAction.sequence([SKAction.run {
                        enemyNode.state = .poison
                    }, SKAction.wait(forDuration: 3), SKAction.run {
                        enemyNode.state = .none
                    }]))
                }
            case .right:
                if node.position.x >= player.position.x && distance <= self.size.height/10 && enemyNode.state != .poison {
                    enemyNode.run(SKAction.sequence([SKAction.run {
                        enemyNode.state = .poison
                    }, SKAction.wait(forDuration: 3), SKAction.run {
                        enemyNode.state = .none
                    }]))
                }
            case .left:
                if node.position.x <= player.position.x && distance <= self.size.height/10 && enemyNode.state != .poison {
                    enemyNode.run(SKAction.sequence([SKAction.run {
                        enemyNode.state = .poison
                    }, SKAction.wait(forDuration: 3), SKAction.run {
                        enemyNode.state = .none
                    }]))
                }
            }
        }
    }
    
}
