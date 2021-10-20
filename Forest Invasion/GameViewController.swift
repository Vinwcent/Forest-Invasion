//
//  GameViewController.swift
//  Invasion
//
//  Created by Vincent Van Wynendaele on 07/05/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    
    
    
    // MARK: - OUTLETS
    
    
    
    
    
    // MARK: - SCENE LOADING
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "TransitionScene") as? TransitionScene {
                scene.size = view.bounds.size
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                scene.navigationController = self.navigationController
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
