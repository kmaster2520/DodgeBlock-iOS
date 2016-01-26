//
//  GameOverScene.swift
//  DodgeBlock-iOS
//
//  Created by Sathvik Kadaveru on 10/17/15.
//  Copyright © 2015 Sathvik Kadaveru. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    var score: UInt32 = 0
    
    override func didMoveToView(view: SKView) {
        let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        border.friction = 0
        self.physicsBody = border
        
        let scoreText = childNodeWithName("finalScoreText") as! SKLabelNode
        scoreText.text = "Score: " + String(score)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)
        
        if let body = self.physicsWorld.bodyAtPoint(location) {
            let theName = body.node!.name
            if theName == "restartButton" || theName == "retryText"{
                let scene = MenuScene(fileNamed: "MenuScene")!
                scene.updateHighScore(score)
                scene.scaleMode = SKSceneScaleMode.AspectFill
                let transition1 = SKTransition.doorsCloseHorizontalWithDuration(0.2)
                self.view!.presentScene(scene, transition: transition1)
                
            }
        }
        
    }
}
