//
//  ShopGameSize.swift
//  ForestInvasion
//
//  Created by Vincent Van Wynendaele on 16/05/2021.
//

import UIKit

extension ShopGameScene {
    
    func setRealSize(width: CGFloat, height: CGFloat) -> CGSize {
        let screenMultiplier = (7*self.size.height/10)/self.size.width
        return CGSize(width: screenMultiplier*width*self.size.width/512, height: height*(7*self.size.height/10)/640)
        
    }
}
