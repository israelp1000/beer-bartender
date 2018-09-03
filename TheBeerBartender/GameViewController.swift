//
//  GameViewController.swift
//  TheBeerBartender
//
//  Created by Israel on 21/12/2017.
//  Copyright © 2017 Israel. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.frame.size)
        
        guard let v = view as? SKView else{return}
        
        
        scene.scaleMode = .aspectFill
        
        v.showsFPS = false
        v.showsNodeCount = false
        v.showsPhysics = false
        v.presentScene(scene)
    }
        

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func transition(sender:UIButton!)
    {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "HighScoreViewController") as! HighScoreViewController
        
        secondViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        let window = UIApplication.shared.windows[0] as UIWindow
        UIView.transition(
            from: window.rootViewController!.view,
            to: secondViewController.view,
            duration: 0.65,
            options: .transitionCrossDissolve,
            completion: {
                finished in window.rootViewController = secondViewController
        })    }
    
}
