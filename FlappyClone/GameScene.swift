//
//  GameScene.swift
//  FlappyClone
//
//  Created by HSIAO JENHAO on 2016-09-21.
//  Copyright © 2016 HSIAO JENHAO. All rights reserved.
//

import SpriteKit

struct PhysicsCatagory {
    static let Bird : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Streetcar : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}



class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var Ground = SKSpriteNode()
    var Bird = SKSpriteNode()
    
    var StreetcarPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int()

    let scoreLbl = SKLabelNode()
   
    var died = Bool()
    var restartBTN = SKSpriteNode()
    
    func restartScene(){
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
        
    }
    
    func createScene(){
        
        print(UIFont.familyNames)
        
        self.physicsWorld.contactDelegate = self
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "toronto2")
            background.anchorPoint = CGPoint.zero
            background.position = CGPoint(x: CGFloat(i) * self.frame.width-500, y: 0)
            background.name = "background"
//            background.size = (self.view?.bounds.size)!
            self.addChild(background)
            
        }
        
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = "\(score)"
        scoreLbl.fontName = "Varsity"
        scoreLbl.fontSize = 60
        scoreLbl.fontColor = SKColor.orange
        scoreLbl.zPosition = 5
        self.addChild(scoreLbl)
        
        Ground = SKSpriteNode(imageNamed: "road")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 3)
        
        Ground.size = CGSize(width: self.frame.width, height: 70)
        Ground.physicsBody = SKPhysicsBody(rectangleOf: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Bird
        Ground.physicsBody?.contactTestBitMask  = PhysicsCatagory.Bird
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.isDynamic = false
        
        Ground.zPosition = 3
        
        self.addChild(Ground)
        
        
        
        Bird = SKSpriteNode(imageNamed: "Bluejay")
        Bird.size = CGSize(width: 60, height: 70)
        Bird.position = CGPoint(x: self.frame.width / 2 - Bird.frame.width, y: self.frame.height / 2)
        
        Bird.physicsBody = SKPhysicsBody(circleOfRadius: Bird.frame.height / 2)
        Bird.physicsBody?.categoryBitMask = PhysicsCatagory.Bird
        Bird.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Streetcar
        Bird.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Streetcar | PhysicsCatagory.Score
        Bird.physicsBody?.affectedByGravity = false
        Bird.physicsBody?.isDynamic = true
        
        Bird.zPosition = 2
        
        
        self.addChild(Bird)
        
        
        
        

        
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        createScene()
        
    }
    
    func createBTN(){
        
        restartBTN = SKSpriteNode(imageNamed: "tryagain")
        restartBTN.size = CGSize(width: 200, height: 200)
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        restartBTN.run(SKAction.scale(to: 1.0, duration: 0.3))
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
      
        if firstBody.categoryBitMask == PhysicsCatagory.Score && secondBody.categoryBitMask == PhysicsCatagory.Bird{
            
            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()

            print ("You get one point A")

            particlerain()
            
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Bird && secondBody.categoryBitMask == PhysicsCatagory.Score {
            
            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()

            print ("You get one point B")
            
        }
        
        else if firstBody.categoryBitMask == PhysicsCatagory.Bird && secondBody.categoryBitMask == PhysicsCatagory.Streetcar || firstBody.categoryBitMask == PhysicsCatagory.Streetcar && secondBody.categoryBitMask == PhysicsCatagory.Bird{
            
            enumerateChildNodes(withName: "StreetcarPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false{
                died = true
                createBTN()
                particleSpark()
                print ("Now you're died")
            }
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Bird && secondBody.categoryBitMask == PhysicsCatagory.Ground || firstBody.categoryBitMask == PhysicsCatagory.Ground && secondBody.categoryBitMask == PhysicsCatagory.Bird{
            
            enumerateChildNodes(withName: "StreetcarPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false{
                died = true
                particleSmoke()
                createBTN()
            }
        }

        
        
        
        
    }

    func particleSmoke()

    {
        if let explosion = SKEmitterNode(fileNamed: "ParticleSmoke") {

            explosion.position = Bird.position

            self.addChild(explosion)
        }
        
    }



    func particleSpark()
    {
        if let explosion = SKEmitterNode(fileNamed: "ParticleSpark") {

            explosion.position = Bird.position

            self.addChild(explosion)
        }

    }

    func particlerain()
    {
        if let explosion = SKEmitterNode(fileNamed: "ParticleRain") {

            explosion.position = Bird.position

            self.addChild(explosion)
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameStarted == false{
            
            gameStarted =  true
            
            Bird.physicsBody?.affectedByGravity = true
            
            let spawn = SKAction.run({
                () in

                
                self.createStreetcars()
                
            })
            
            let delay = SKAction.wait(forDuration: 1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(SpawnDelay)
            self.run(spawnDelayForever)
            
            
            let distance = CGFloat(self.frame.width + StreetcarPair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 300, y:200, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            Bird.physicsBody?.velocity = CGVector(dx: 0, dy: 100)
            Bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
        }
        else{
            
            if died == true{
                
            }
            else{
                Bird.physicsBody?.velocity = CGVector(dx: 0, dy: 100)
                Bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
            }
            
        }
        
        
        
        
        for touch in touches{
            let location = touch.location(in: self)
            
            if died == true{
                if restartBTN.contains(location){
                    restartScene()
                    
                }
                
                
            }
            
        }
        
        
        
        
        
        
    }
    
    func createStreetcars(){
        
        let scoreNode = SKSpriteNode(imageNamed: "gold")
        
        scoreNode.size = CGSize(width: 70, height: 70)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird
        scoreNode.color = SKColor.blue
        
        
        StreetcarPair = SKNode()
        StreetcarPair.name = "StreetcarPair"
        
        let topStreetcar = SKSpriteNode(imageNamed: "streetcar")
        let btmStreetcar = SKSpriteNode(imageNamed: "streetcar")
        
        topStreetcar.position = CGPoint(x: self.frame.width + 100, y: self.frame.height / 2 + 350)
        btmStreetcar.position = CGPoint(x: self.frame.width + 150, y: self.frame.height / 2 - 350)
        
        topStreetcar.setScale(0.5)
        btmStreetcar.setScale(0.5)
        
        
        topStreetcar.physicsBody = SKPhysicsBody(rectangleOf: topStreetcar.size)
        topStreetcar.physicsBody?.categoryBitMask = PhysicsCatagory.Streetcar
        topStreetcar.physicsBody?.collisionBitMask = PhysicsCatagory.Bird
        topStreetcar.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird
        topStreetcar.physicsBody?.isDynamic = false
        topStreetcar.physicsBody?.affectedByGravity = false
        
        btmStreetcar.physicsBody = SKPhysicsBody(rectangleOf: btmStreetcar.size)
        btmStreetcar.physicsBody?.categoryBitMask = PhysicsCatagory.Streetcar
        btmStreetcar.physicsBody?.collisionBitMask = PhysicsCatagory.Bird
        btmStreetcar.physicsBody?.contactTestBitMask = PhysicsCatagory.Bird
        btmStreetcar.physicsBody?.isDynamic = false
        btmStreetcar.physicsBody?.affectedByGravity = false

        topStreetcar.zRotation = CGFloat(M_PI)
        
        StreetcarPair.addChild(topStreetcar)
        StreetcarPair.addChild(btmStreetcar)
        
        StreetcarPair.zPosition = 1
        
        let randomPosition = CGFloat.random(min: -300, max: 300)
         StreetcarPair.position.y = StreetcarPair.position.y +  randomPosition
        StreetcarPair.addChild(scoreNode)
        
        StreetcarPair.run(moveAndRemove)
        
        self.addChild(StreetcarPair)
        
    }
    
    
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if gameStarted == true{
            if died == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    
                    let bg = node as! SKSpriteNode
                    
                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)
                    
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width * 2, y: bg.position.y)
                        
                    }
                    
                }))
                
            }
            
            
        }
        
        
        
        
    }
}
