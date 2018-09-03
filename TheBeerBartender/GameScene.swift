//
//  GameScene.swift
//  TheBeerBartender
//
//  Created by Israel on 21/12/2017.
//  Copyright © 2017 Israel. All rights reserved.

import SpriteKit
import GameplayKit

let GlassCategory:UInt32 = 1
let VisitorCategory:UInt32 = 2
let BarrelCategory:UInt32 = 4
let BartenderCategory:UInt32 = 8
let TableCategory:UInt32 = 16
let FrameCategory:UInt32 =  32

let labelLevel = SKLabelNode()
var level = 1
let topicLabelScore = SKLabelNode()
let labelScore = SKLabelNode()
var score = 0
let labelLife = SKLabelNode()
let labelSound = SKLabelNode()

var life = 3
var newScore = score
var waitForAnimateLoss = false
var allowSound = true

let barra = SKSpriteNode()
let barra2 = SKSpriteNode()
var prosseValue = 5
var tile = SKShapeNode()
var tile2 = SKShapeNode()

class GameScene: SKScene , SKPhysicsContactDelegate{
    //play Sound:
    func playSoundGlassBroke(){
        if allowSound{
    let playSoundGlassBroke = SKAction.playSoundFileNamed("glassbreaks", waitForCompletion: false)
        run(playSoundGlassBroke)
        }}
    func playSoundGlassHit(){
        if allowSound{
        let playSoundGlassHit = SKAction.playSoundFileNamed("glasshit", waitForCompletion: false)
            run(playSoundGlassHit)
        }}
    func playSoundGlassSend(){
        if allowSound{
        let playSoundGlassSend = SKAction.playSoundFileNamed("glasssend", waitForCompletion: false)
            run(playSoundGlassSend)
        }}
    func playSoundStart() {
        if allowSound{
        let playSoundStart = SKAction.playSoundFileNamed("glass_ping", waitForCompletion: false)
            run(playSoundStart)
        }}
    func playSoundBarrelBroke(){
        if allowSound{
        let playSoundBarrelBroke = SKAction.playSoundFileNamed("bomb", waitForCompletion: false)
            run(playSoundBarrelBroke)
        }}
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        //contact!
        var bodyA = contact.bodyA
        var bodyB = contact.bodyB
        
        if bodyA.categoryBitMask > bodyB.categoryBitMask{
            bodyB = contact.bodyA
            bodyA = contact.bodyB
        }
        
        if bodyA.categoryBitMask==VisitorCategory { //visitor mach
            if bodyB.categoryBitMask==BarrelCategory{
            }
        }else if
            bodyA.categoryBitMask == GlassCategory{//glass mach
            
            if bodyB.categoryBitMask == VisitorCategory  {
                score += 10*level
                labelScore.text = String(score)
                //glass-> visitor
                numOfVisitors -= 1
                prosseValue += 20/level
                
                barra2.size.height = CGFloat(prosseValue)
                barra2.position.y = 20+barra2.frame.height/2
                if barra2.size.height >= barra.size.height-10{
                    nextLevel()
                }
                
                visitorGoBack(nodeA: bodyA.node!, nodeB: bodyB.node!)
            }else if
                bodyB.categoryBitMask == FrameCategory {//glass-> frame
                braekGlass(node: bodyA.node!)
                lostLife()
            }else if bodyB.categoryBitMask == GlassCategory  {//glass-> glass
            }
            else if bodyB.categoryBitMask == BartenderCategory  {//glass-> bartender
            }
        }else if
            bodyA.categoryBitMask == BarrelCategory{  //barrel mach
            if bodyB.categoryBitMask == FrameCategory{//barrel broke!
                
                braekBarrel(node: bodyA.node!)
                lostLife()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
    }
    
    override func didMove(to view: SKView) {
        waitForAnimateLoss = false
        addBackground()
        playSoundStart()
        barra.name = "barra"
        barra.size = CGSize(width: 20, height: frame.height - 30)
        barra.color = SKColor.brown
        barra.position = CGPoint(x: frame.maxX - 30, y: frame.midY)
        self.addChild(barra)
        
        barra2.name = "barra2"
        barra2.size = CGSize(width: 15, height: prosseValue)
        barra2.color = SKColor.orange
        barra2.position = CGPoint(x: barra.frame.midX, y: 20+barra2.frame.height/2 )
        self.addChild(barra2)
        
        let prossesBar = SKSpriteNode()
        prossesBar.name = "prossesBar"
        prossesBar.position = CGPoint(x: frame.maxX-20, y: frame.height * 0.9)
        addChild(prossesBar)
        
        labelLevel.name = "lableScore"
        labelLevel.position = CGPoint(x: frame.width * 0.4, y: frame.height * 0.9)
        labelLevel.fontSize = 25
        labelLevel.fontName = "Arial"
        labelLevel.text = "Level: " + String(level)
        addChild(labelLevel)
        
        labelScore.name = "lableScore"
        labelScore.position = CGPoint(x: frame.width * 0.1, y: frame.height * 0.9)
        labelScore.fontSize = 30
        labelScore.fontName = "Arial"
        labelScore.text = String(score)
        addChild(labelScore)
        
        labelLife.name = "lifeScore"
        labelLife.position = CGPoint(x: frame.width * 0.7, y: frame.height * 0.9)
        var l = ""
        for _ in 1...life   {
            l += "\u{1F496}"
            labelLife.text = l
        }
        addChild(labelLife)
        
        addFrame()
        add4Table()
        
        let timer = TimeInterval(12/(Double(level) + 5.0)+0.5)
        startSpawning(randomTime: timer)
        addBartener()
        addSound()
        
        //register self as the delegate
        physicsWorld.contactDelegate = self
    }
    
    func addSound(){
        labelSound.name = "sound"
        labelSound.position = CGPoint(x: frame.width * 0.90, y: frame.height * 0.90)
        if allowSound{
            labelSound.text = "\u{1F514}"}
        addChild(labelSound)
    }
    
    func toggleSound(){
        if allowSound{
            labelSound.text = "\u{1F514}"
        }else{
            labelSound.text = "\u{1F515}"
        }
    }
    
    func addFrame(){
        let misgeret = SKPhysicsBody(edgeLoopFrom: frame)
        self.physicsBody = misgeret
        self.physicsBody?.categoryBitMask = FrameCategory
        self.physicsBody?.contactTestBitMask = GlassCategory
    }
    
    func lostLife(){
        if !waitForAnimateLoss{
            waitForAnimateLoss = true

        if life==1 {
            gameOver(); return;
        }
        
        let back = SKSpriteNode(color: UIColor.black, size: CGSize(width: frame.width, height: frame.height)) //35
        back.position = CGPoint(x: frame.midX, y: frame.midY)
        back.alpha = 0.5
        
        addChild(back)

        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "You lost a life"
        myLabel.fontColor = UIColor(displayP3Red: 5, green: 0.2, blue: 0.1, alpha: 0.9)
        myLabel.fontSize = 70
        myLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        
        self.addChild(myLabel)
        life-=1
        reloadScene()
        }
    }
    
    func gameOver(){
        
        self.scene?.removeAllChildren()
        self.scene?.removeAllActions()
        
        playSoundBarrelBroke()
        
        let emiter = SKEmitterNode(fileNamed: "glassbroken1")!
        emiter.position = self.position
        addChild(emiter)
        
        topicLabelScore.name = "topicLabelScore"
        topicLabelScore.position = CGPoint(x: frame.midX, y: frame.midY)
        topicLabelScore.fontName = "Arial"
        topicLabelScore.text = "score:"
        addChild(topicLabelScore)
        labelScore.position = CGPoint(x: frame.midX, y: frame.midY - 70)
        labelScore.fontSize = 60
        addChild(labelScore)
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "GameOver!"
        myLabel.fontSize = 65
        myLabel.position = CGPoint(x: (self.view?.frame.size.width)! * 0.5, y: (self.view?.frame.size.height)! * 0.65)
        self.addChild(myLabel)
        
        gameIsOver = true
    }
    
    func addBackground(){
        let imgname = "back\(30 + level%30)"
        let back = SKSpriteNode(imageNamed: imgname)
        back.position = CGPoint(x: frame.midX, y: frame.midY)
        back.size = CGSize(width: frame.width, height: frame.height)
        addChild(back)
    }
    
    func add4Table(){
        for i in 1...4        {
            let table = SKSpriteNode(imageNamed: "table00")

            let tableY = Int(frame.maxY * 0.84)/4 * i - Int(frame.maxY / 10)
            table.position = CGPoint(x: Int(frame.midX) - 20, y: tableY)

        table.size = CGSize(width: frame.width * 0.85, height: frame.height * 0.08)
            table.physicsBody = SKPhysicsBody(texture: table.texture!, size: table.size)
            table.physicsBody?.isDynamic = false
            
            addChild(table)
            
            let beerBarrel = SKSpriteNode(imageNamed: "beerbarrel")
            beerBarrel.size = CGSize(width: frame.size.height / 14, height: frame.size.height / 14)
            beerBarrel.position = CGPoint(x: Int(table.position.x * 1.75 ) , y: Int(table.position.y + frame.maxY / 15) )
            beerBarrel.physicsBody = SKPhysicsBody.init(rectangleOf: beerBarrel.size)
            beerBarrel.physicsBody?.categoryBitMask = BarrelCategory
            beerBarrel.physicsBody?.contactTestBitMask = FrameCategory
            beerBarrel.name = "beerbarrel\(i)"
            addChild(beerBarrel)
        }
    }
    
    func addBartener(){
        let bartender = SKSpriteNode(imageNamed: "bartender")
        bartender.size = CGSize(width: self.frame.size.height / 8, height: self.frame.size.height / 6)
        bartender.position = CGPoint(x: frame.width*0.92, y: frame.height*0.2)
        bartender.name = "bartender"
        bartender.physicsBody?.categoryBitMask = BartenderCategory
        addChild(bartender)
    }
    
    func addGlass(pointX: CGFloat,pointY: CGFloat){
        
        //Check if there is already a glass in the game...
        let g = childNode(withName: "glass")?.canBecomeFocused
        if (g != nil) {return}
        //
        let glass = SKSpriteNode(imageNamed: "barglass")
        glass.size = CGSize(width: 20, height: 20)
        glass.position = CGPoint(x: pointX - frame.maxX / 40 , y: pointY)
        glass.name = "glass"
        glass.physicsBody = SKPhysicsBody(rectangleOf: glass.size)
        
        glass.physicsBody?.categoryBitMask = GlassCategory
        glass.physicsBody?.contactTestBitMask = FrameCategory | BartenderCategory | VisitorCategory
        playSoundGlassSend()
        addChild(glass)
        glass.physicsBody?.applyImpulse(CGVector(dx: -15, dy: 2))
    }
    
    func braekGlass(node:SKNode){
        playSoundGlassBroke()
        let emiter = SKEmitterNode(fileNamed: "glassbroken50")!
        emiter.name = "emiterGameOver"
        emiter.position = node.position
        addChild(emiter)
        node.removeFromParent()
    }
    
    func braekBarrel(node:SKNode){
        playSoundBarrelBroke()
        let emiter = SKEmitterNode(fileNamed: "broken2")!
        emiter.name = "braekbatle"
        emiter.position = node.position
        addChild(emiter)
        node.removeFromParent()
    }
    
    var numOfVisitors = 0
    var timeRandom = arc4random_uniform(4)
    
    func startSpawning(randomTime:TimeInterval){
        
        let s = SKAction.run {
            let randomSpeed = arc4random_uniform(15)
            self.numOfVisitors += 1 //for detected next level...
            let visitor = SKSpriteNode(imageNamed: "bar0")
            visitor.size = CGSize(width: self.frame.size.height / 6, height: self.frame.size.height / 6)
            visitor.physicsBody = SKPhysicsBody(rectangleOf: visitor.size)
            visitor.physicsBody?.isDynamic = false
            let posY = Int(self.frame.maxY * 0.84)/4 * Int(arc4random_uniform(4)+1) - Int(self.frame.maxY / 15)
            visitor.position = CGPoint(x: 99, y: posY)
            visitor.physicsBody?.categoryBitMask = VisitorCategory
            visitor.name = "visitor"
            visitor.physicsBody?.contactTestBitMask = GlassCategory | BartenderCategory | FrameCategory | BarrelCategory
            
            //random speed for walk
            let walkSpeed =  100 / (level + 6) + Int(randomSpeed) + 5
            
            visitor.run(SKAction.moveTo(x: CGFloat(self.frame.width), duration: TimeInterval(walkSpeed)))

            var walkArrey:[SKTexture] = []
            
            for i in 1...10{
                var img = SKTexture()
                
                //if he go fast:
                if (randomSpeed < 3 && level > 4)
                {img = SKTexture(imageNamed: "RunN\(i)")}
                else if (randomSpeed < 6 && level > 3)
                {img = SKTexture(imageNamed: "Run\(i)")}
                else if (randomSpeed < 9 && level > 2)
                {img = SKTexture(imageNamed: "WalkN\(i)")}
                else if (randomSpeed < 12 && level > 1)
                {img = SKTexture(imageNamed: "WalkG\(i)")}
                else
                {img = SKTexture(imageNamed: "Walk\(i)")}
            
                walkArrey.append(img)
            }
            // animate per speed:
            let go = SKAction.animate(with: walkArrey, timePerFrame:  0.005*Double(walkSpeed), resize: false, restore: false)
            let rForEver = SKAction.repeatForever(go)
            self.addChild(visitor)
            visitor.run(rForEver)}
        
        let repeatOneMore = SKAction.run {
            self.startSpawning(randomTime: randomTime)
        }
        let timeIntervalForWait = randomTime
        
        let w = SKAction.wait(forDuration: TimeInterval (timeIntervalForWait) )
        
        let all = SKAction.sequence([s, w, repeatOneMore])
        let r = SKAction.repeat(all, count: 1)
        
        self.run(r, withKey: "spawn")
    }
    
    func visitorGoBack(nodeA: SKNode, nodeB: SKNode){
        
        let fade = SKAction.fadeOut(withDuration: 2.3)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([ remove, fade])
        nodeA.removeAllChildren()
        nodeB.position = nodeA.position
        
        let checkForNextLevel = SKAction.run {
            
            if (self.numOfVisitors == 0) {
               // print("clear!!")
                self.removeAllChildren()
                self.removeAllActions()
                self.nextLevel()
            }
        }
        let seq2 = SKAction.sequence([SKAction.moveTo(x: CGFloat(0), duration: 0.5), checkForNextLevel,seq])
        nodeA.run(seq, withKey: "visitorGoBack")
        nodeB.run(seq2, withKey: "glassGoBack")
    }
    var isSuondTuchd = false
    var isFingerOnBartender = false
    var isFingerOnBarrel = false
    var gameIsOver = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameIsOver {
            gameIsOver = false; self.exsitScene()
        }
        
        let point = touches.first!.location(in: self)
        
        guard let sound = childNode(withName: "sound") else {return}

        guard let barT = childNode(withName: "bartender") else {return}
        guard let barrel1 = childNode(withName: "beerbarrel1")else{return}
        guard let barrel2 = childNode(withName: "beerbarrel2")else{return}
        guard let barrel3 = childNode(withName: "beerbarrel3")else{return}
        guard let barrel4 = childNode(withName: "beerbarrel4")else{return}
        
        isSuondTuchd = sound.frame.contains(point)
        isFingerOnBartender = barT.frame.contains(point)
        isFingerOnBarrel = barrel1.frame.contains(point)||barrel2.frame.contains(point)||barrel3.frame.contains(point)||barrel4.frame.contains(point)
        
        if isSuondTuchd{
            if allowSound{allowSound = false}else{allowSound=true}
            toggleSound()
        }
        
        
        if isFingerOnBarrel{
            let shake = SKAction.rotate(toAngle: -0.3, duration: 0.3, shortestUnitArc: true)
            
            if barrel1.frame.contains(point){ barrel1.run(shake)
            }
            else if barrel2.frame.contains(point){ barrel2.run(shake)
            }
            else if barrel3.frame.contains(point){ barrel3.run(shake)
            }
            else if barrel4.frame.contains(point){ barrel4.run(shake)
            }
            
            var d = point.y - barT.frame.midY
            d = d/500
            if d <= 0 {d=d*(-1)}
            let goWark = SKAction.move(to: CGPoint(x: point.x + frame.height / 14 , y: point.y-20), duration: TimeInterval(d))
            
            let addGlass = SKAction.run {
                self.addGlass(pointX: point.x-50, pointY: point.y)
            }
            
            let goWarkAndWait = SKAction.sequence([goWark,addGlass])
            barT.run(goWarkAndWait)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isFingerOnBartender else {return}
        
        let point = touches.first!.location(in: self)
        let barT = childNode(withName: "bartender")!
        
        barT.position.y = point.y
        let xy = 690 - point.y / 1.8
        barT.position.x = xy
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnBarrel=false
        isFingerOnBartender=false
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnBarrel=false
        isFingerOnBartender=false
    }
    override func update(_ currentTime: TimeInterval) {
        //
    }
    
    func reloadScene(){
        
        var seq:SKAction;
        seq = SKAction.sequence([SKAction.wait(forDuration: 1.5),SKAction.run {
            self.scene?.removeAllChildren()
            self.scene?.removeAllActions()
            self.scene?.removeFromParent()
            let scene2:SKScene = GameScene(size: self.size)
            self.view?.presentScene(scene2)
            }])
        run(seq)
    }
        
    func exsitScene(){
        self.scene?.removeAllActions()
        self.scene?.removeAllChildren()
        newScore = score
        score = 0
        life = 3
        level = 1
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        let window = UIApplication.shared.windows[0] as UIWindow
        UIView.transition(
            from: window.rootViewController!.view,
            to: loginViewController.view,
            duration: 0.65,
            options: .transitionCrossDissolve,
            completion: {
                finished in window.rootViewController = loginViewController
        })
//exit!
    }
    
    func nextLevel(){
        prosseValue=5
        score+=1000*level
        level+=1
        
        if level%5 == 0 {life += 1}

        labelLevel.text = String(level)
        addBackground()

        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Level " + String(level)
        myLabel.fontSize = 65
        myLabel.position = CGPoint(x: (self.view?.frame.size.width)! * 0.5, y: (self.view?.frame.size.height)! * 0.65)
        self.addChild(myLabel)
        
        self.reloadScene()
    }
}



