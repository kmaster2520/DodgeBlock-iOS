//
//  GameScene.swift
//  DodgeBlock-iOS
//
//  Created by Sathvik Kadaveru on 10/17/15.
//  Copyright (c) 2015 Sathvik Kadaveru. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let playerCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    let edgeCategory: UInt32 = 0x1 << 2
    
    let blockSpeed: CGFloat = 600
    
    var isTouchingPlayer: Bool = false
    var score: UInt32 = 0
    var enemiesSpawned: UInt32 = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        /*let border = SKPhysicsBody(edgeLoopFromRect: self.frame)
        border.friction = 0
        self.physicsBody = border*/
        self.physicsWorld.contactDelegate = self
        
        let player = childNodeWithName("player") as! SKSpriteNode
        player.physicsBody!.categoryBitMask = playerCategory
        player.physicsBody!.contactTestBitMask = enemyCategory
        
        let scoreText = childNodeWithName("scoreText") as! SKLabelNode
        scoreText.position.x = self.size.width - 230
        scoreText.position.y = self.size.height - 50
        scoreText.text = "Score: " + String(score)
        
        let top = childNodeWithName("top") as! SKSpriteNode
        top.physicsBody!.categoryBitMask = edgeCategory
        let bottom = childNodeWithName("bottom") as! SKSpriteNode
        bottom.physicsBody!.categoryBitMask = edgeCategory
        let left = childNodeWithName("left") as! SKSpriteNode
        left.physicsBody!.categoryBitMask = edgeCategory
        let right = childNodeWithName("right") as! SKSpriteNode
        right.physicsBody!.categoryBitMask = edgeCategory
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)

        if let body = self.physicsWorld.bodyAtPoint(location) {
            if body.node!.name == "player" {
                isTouchingPlayer = true
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !isTouchingPlayer {
            return;
        }
        let touch = touches.first as UITouch!
        let location = touch.locationInNode(self)
        let prevLocation = touch.previousLocationInNode(self)
        
        let player = childNodeWithName("player") as! SKSpriteNode
        var xPos = player.position.x + (location.x - prevLocation.x)
        var yPos = player.position.y + (location.y - prevLocation.y)
        xPos = max(xPos, player.size.width / 2)
        xPos = min(xPos, size.width - player.size.width / 2)
        yPos = max(yPos, player.size.height / 2)
        yPos = min(yPos, size.height - player.size.height / 2)
        player.position = CGPointMake(xPos, yPos)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        isTouchingPlayer = false
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var first: SKPhysicsBody
        var second: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            first = contact.bodyA
            second = contact.bodyB
        } else {
            first = contact.bodyB
            second = contact.bodyA
        }
        
        if first.categoryBitMask == enemyCategory && second.categoryBitMask == edgeCategory {
            first.node!.removeFromParent()
            score++
            let scoreText = childNodeWithName("scoreText") as! SKLabelNode
            scoreText.text = "Score: " + String(score)
        }
        if first.categoryBitMask == playerCategory && second.categoryBitMask == enemyCategory {
            let scene = GameOverScene(fileNamed: "GameOverScene")!
            scene.score = self.score
            //print("player collide")
            scene.scaleMode = SKSceneScaleMode.AspectFill
            let transition1 = SKTransition.doorsCloseHorizontalWithDuration(0.2)
            self.view!.presentScene(scene, transition: transition1)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        let randd = Int(arc4random_uniform(200))
        if randd <= Int(4 + score / 10) {
            let enemy = SKSpriteNode(color: UIColor.redColor(), size: CGSizeMake(32, 32))
            enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.frame.size)
            enemy.physicsBody!.allowsRotation = false
            enemy.physicsBody!.friction = 0
            enemy.physicsBody!.restitution = 1
            enemy.physicsBody!.linearDamping = 0
            enemy.physicsBody!.angularDamping = 0
            enemy.physicsBody!.affectedByGravity = true
            enemy.physicsBody!.dynamic = true
            enemy.physicsBody!.pinned = false
            enemy.physicsBody!.allowsRotation = false
            enemy.physicsBody!.categoryBitMask = enemyCategory
            enemy.physicsBody!.collisionBitMask = edgeCategory | playerCategory
            enemy.physicsBody!.contactTestBitMask = enemy.physicsBody!.collisionBitMask
            addChild(enemy)
            let px: CGFloat
            let py: CGFloat
            let rand = Int(arc4random_uniform(4))
            if rand == 0 {
                px = CGFloat(arc4random_uniform(UInt32(self.frame.width)))
                py = self.frame.height
                enemy.physicsBody!.velocity.dx = 0
                enemy.physicsBody!.velocity.dy = -blockSpeed
            } else if rand == 1 {
                px = CGFloat(arc4random_uniform(UInt32(self.frame.width)))
                py = 0
                enemy.physicsBody!.velocity.dx = 0
                enemy.physicsBody!.velocity.dy = blockSpeed
            } else if rand == 2 {
                px = 0
                py = CGFloat(arc4random_uniform(UInt32(self.frame.height)))
                enemy.physicsBody!.velocity.dx = blockSpeed
                enemy.physicsBody!.velocity.dy = 0
            } else {// if rand == 3
                px = self.frame.width
                py = CGFloat(arc4random_uniform(UInt32(self.frame.height)))
                enemy.physicsBody!.velocity.dx = -blockSpeed
                enemy.physicsBody!.velocity.dy = 0
            }
            
            enemy.position = CGPointMake(px, py)
            enemiesSpawned++
            //print(enemiesSpawned)
        }
        
    }
}
