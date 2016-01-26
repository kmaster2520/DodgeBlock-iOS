//
//  MenuScene.swift
//  DodgeBlock-iOS
//
//  Created by Sathvik Kadaveru on 10/17/15.
//  Copyright © 2015 Sathvik Kadaveru. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    
    static var highScore: UInt32 = 0
    
    override func didMoveToView(view: SKView) {
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        border.friction = 0
        self.physicsBody = border
        
        let scoreText = childNodeWithName("highScoreText") as! SKLabelNode
        scoreText.text = "High Score: " + String(MenuScene.highScore)
        //print(Int("+08")!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)
        
        if let body = self.physicsWorld.bodyAtPoint(location) {
            let theName = body.node!.name
            if theName == "startButton" || theName == "startText" {
                let scene = GameScene(fileNamed: "GameScene")!
                scene.scaleMode = SKSceneScaleMode.AspectFill
                let transition1 = SKTransition.doorsCloseHorizontalWithDuration(0.2)
                self.view!.presentScene(scene, transition: transition1)
            }
        }
        
    }
    
    func updateHighScore(i: UInt32) {
        if i > MenuScene.highScore {
            MenuScene.highScore = i
            let scoreText = childNodeWithName("highScoreText") as! SKLabelNode
            scoreText.text = "High Score: " + String(MenuScene.highScore)
        }
    }

}
