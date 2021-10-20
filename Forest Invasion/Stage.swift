//
//  Stage.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 16/05/2021.
//

import SpriteKit

class Stage {
    
    static var currentStage:Float = 1
    
    var stageNumber:Float // If not Float, there's a fatal error in timeBetweenBatch than can't be solved otherwise
    var enemiesSpawned:Float = 0
    var amountOfEnemies:Float = 0
    var timeBetweenBatch:TimeInterval = 0
    var enemyPool: [Enemy.EnemyType] = [Enemy.EnemyType.skeleton, Enemy.EnemyType.mushroom1, Enemy.EnemyType.treant, Enemy.EnemyType.ogre]
    
    init(stage: Float) {
        self.stageNumber = stage
        self.amountOfEnemies = self.defineAmountOfEnemies(stage: stage)
        self.timeBetweenBatch = TimeInterval(self.defineTimeBetweenBatch(stage: stage))
        if stage >= 2 {
            enemyPool.append(Enemy.EnemyType.hiddenMole)
        }
        if stage >= 3 {
            enemyPool.append(Enemy.EnemyType.whiteTreant)
        }
    }
    
    private func averageTimeInStage(stage: Float) -> Float {
        return 60*(1-exp(0.1*(1-stage))/2)
    }
    
    private func defineAmountOfEnemies(stage: Float) -> Float {
        return 20*stage
    }
    
    private func defineTimeBetweenBatch(stage: Float) -> Float {
        return 2*averageTimeInStage(stage: stage)/defineAmountOfEnemies(stage: stage)
    }
    
}
