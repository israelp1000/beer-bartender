//
//  GameOverScene.swift
//  TheBeerBartender
//
//  Created by Israel on 07/05/2018.
//  Copyright © 2018 Israel. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene , SKSpriteNode{
    init(size: CGSize, won:Bool) {
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.white
        
        // 2
        let message = won ? "You Won!" : "You Lose :["
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // 4
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() { [weak self] in
                // 5
                guard let `self` = self else { return }
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let loseAction = SKAction.run() {
        let ss = CGSize(width: 100, height: 100)
        
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: ss, won: false)
        
//         GameScene .presentScene(gameOverScene, transition: reveal)
    }
    monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    
    
    
}
