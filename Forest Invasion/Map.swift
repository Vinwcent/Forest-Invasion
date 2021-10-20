//
//  Map.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 24/07/2021.
//

import Foundation
import SpriteKit
import GameKit

class Map: SKSpriteNode {
    
    enum TileType {
        case monsterDiscovered, monster, shop
    }
    
    var matrixMap: [[Int]] = [[0,0,0,0],
                              [0,0,0,0],
                              [0,0,0,0],
                              [0,0,0,0]]
    
    var actualPosition: [Int] = [0,0]
    var indicator:SKSpriteNode
    var isShowed: Bool = false
    var actualTileType: TileType?
    
    init() {
        let texture = SKTexture(imageNamed:"emptyMap")
        indicator = SKSpriteNode(imageNamed:"indicator1")
        
        super.init(texture: texture, color: UIColor.gray, size: CGSize(width: 0, height: 0))
        indicator.zPosition = 2
        self.addChild(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Direction {
        case up,right,down,left
    }
    
    
    // MARK: - LOGIC
    
    func giveMeTheCenterOfTheTile(i: Int, j: Int) -> CGPoint {
        let tileSize=self.size.width/6
        return CGPoint(x: 3*tileSize/2 + CGFloat(j)*tileSize - self.size.width/2, y: -3*tileSize/2 - CGFloat(i)*tileSize + self.size.height/2)
    }
    
    func updateTheIndicator() {
        indicator.run(SKAction.move(to: giveMeTheCenterOfTheTile(i: actualPosition[0], j: actualPosition[1]), duration: 1))
        indicator.size = CGSize(width: self.size.width/18, height: 11/9*self.size.width/18)
        
        
        // MARK: - MAP GENERATION
        
        if matrixMap[actualPosition[0]][actualPosition[1]] == 0 {
            var tile: SKSpriteNode
            if !checkInMatrix(number: 2) {
                matrixMap[actualPosition[0]][actualPosition[1]] = 2
                actualTileType = .shop
                tile = SKSpriteNode(imageNamed: "shopTile")
            } else {
                matrixMap[actualPosition[0]][actualPosition[1]] = 1
                actualTileType = .monster
                tile = SKSpriteNode(imageNamed: "monsterTile1")
            }
            tile.size = CGSize(width: self.size.width/6, height: self.size.width/6)
            tile.position = giveMeTheCenterOfTheTile(i: actualPosition[0], j: actualPosition[1])
            tile.zPosition = 1
            self.addChild(tile)
            
            
        } else if  matrixMap[actualPosition[0]][actualPosition[1]] == 1 {
            actualTileType = .monsterDiscovered
        } else if matrixMap[actualPosition[0]][actualPosition[1]] == 2 {
            actualTileType = .shop
        }
    }
    
    func updateTheMap(direction: Direction) {
        switch direction {
        case .up:
            actualPosition[0] -= 1
        case .right:
            actualPosition[1] += 1
        case .down:
            actualPosition[0] += 1
        case .left:
            actualPosition[1] -= 1
        }
        updateTheIndicator()
    }
    
    func pullOutTheMap() {
        if !isShowed {
            self.run(SKAction.moveBy(x: 3.5*self.size.width/4, y: 0, duration: 0.5))
            isShowed = true
        }
    }
    
    func putAwayTheMap() {
        if isShowed {
            self.run(SKAction.moveBy(x: -3.5*self.size.width/4, y: 0, duration: 0.5))
            isShowed = false
        }
    }
    
    func checkInMatrix(number: Int) -> Bool {
        for i in 0...3 {
            for j in 0...3 {
                if matrixMap[i][j] == number {
                    return true
                }
            }
        }
        return false
    }
    
}
