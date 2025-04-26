//
//  GameScene.swift
//  Shooting Gallery Arcade
//
//  Created by Randy Robinson on 2/27/22.
//

import SpriteKit
import SceneKit
import GameplayKit
import CoreMotion
import SwiftUI
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    let motionManager = CMMotionManager()
    let background = SKSpriteNode(imageNamed: "ShootingGalleryArcade2.png")
    let gameTitle = SKLabelNode(fontNamed: "STENCIL")
    let lblLevel = SKLabelNode(fontNamed: "STENCIL")
    let lblTimer = SKLabelNode(fontNamed: "STENCIL")
    let lblScore = SKLabelNode(fontNamed: "STENCIL")
    let lblHits = SKLabelNode(fontNamed: "STENCIL")
    let lblMisses = SKLabelNode(fontNamed: "STENCIL")
    let textLevel = SKLabelNode(fontNamed: "STENCIL")
    let textTimer = SKLabelNode(fontNamed: "STENCIL")
    let textScore = SKLabelNode(fontNamed: "STENCIL")
    let textHits = SKLabelNode(fontNamed: "STENCIL")
    let textMisses = SKLabelNode(fontNamed: "STENCIL")
    let lblGameOver = SKLabelNode(fontNamed: "STENCIL")
    

    let case1 = SKSpriteNode(imageNamed: "Non-AnimatedShelves.png")
    let case2 = SKSpriteNode(imageNamed: "AnimatedShelves.png")
    
    //let airRifle = SCNNode(Scene: "RifleScene")
    
    let spinningWheel = SKSpriteNode(imageNamed: "SpinningWheel.png")
    let target1 = SKSpriteNode(imageNamed: "Target-1.png")
    let target2 = SKSpriteNode(imageNamed: "Target-2.png")
    let target3 = SKSpriteNode(imageNamed: "Target3.png")
    let target4 = SKSpriteNode(imageNamed: "Target-4.png")
    let target5 = SKSpriteNode(imageNamed: "Target-5.png")
    
    let milkBottle1 = SKSpriteNode(imageNamed: "MilkBottle.png")
    let milkBottle2 = SKSpriteNode(imageNamed: "MilkBottle.png")
    let milkBottle3 = SKSpriteNode(imageNamed: "MilkBottle.png")
    let milkBottle4 = SKSpriteNode(imageNamed: "MilkBottle.png")
    let milkBottle5 = SKSpriteNode(imageNamed: "MilkBottle.png")
    let milkBottle6 = SKSpriteNode(imageNamed: "MilkBottle.png")
    let milkBottle7 = SKSpriteNode(imageNamed: "MilkBottle.png")
    let milkBottle8 = SKSpriteNode(imageNamed: "MilkBottle.png")
    let sodaCan1 = SKSpriteNode(imageNamed: "SodaCan.png")
    let sodaCan2 = SKSpriteNode(imageNamed: "SodaCan.png")
    let sodaCan3 = SKSpriteNode(imageNamed: "SodaCan.png")
    let sodaCan4 = SKSpriteNode(imageNamed: "SodaCan.png")
    let sodaCan5 = SKSpriteNode(imageNamed: "SodaCan.png")
    let sodaCan6 = SKSpriteNode(imageNamed: "SodaCan.png")
    let sodaCan7 = SKSpriteNode(imageNamed: "SodaCan.png")
    
    var balloonOriginalPositions: [[Double]] = Array(repeating: Array(repeating: 0, count: 3), count: 10)
    //var balloonCurrentPositions: [[Double]] = Array(repeating: Array(repeating: 0, count: 3), count: 10)
    
    let balloon1 = SKSpriteNode(imageNamed: "YellowBalloon.png")
    let balloon2 = SKSpriteNode(imageNamed: "RedBalloon.png")
    let balloon3 = SKSpriteNode(imageNamed: "OrangeBalloon.png")
    let balloon4 = SKSpriteNode(imageNamed: "BlueBalloon.png")
    let balloon5 = SKSpriteNode(imageNamed: "GreenBalloon.png")
    let balloon6 = SKSpriteNode(imageNamed: "PurpleBalloon.png")
    let balloon7 = SKSpriteNode(imageNamed: "LtBlueBalloon.png")
    let balloon8 = SKSpriteNode(imageNamed: "GreenBalloon.png")
    let balloon9 = SKSpriteNode(imageNamed: "RedBalloon.png")
    let balloon10 = SKSpriteNode(imageNamed: "PinkBalloon.png")

    let rubberDuckie1 = SKSpriteNode(imageNamed: "RubberDuckie-Right-Yellow.png")
    let rubberDuckie2 = SKSpriteNode(imageNamed: "RubberDuckie-Right-Green.png")
    let rubberDuckie3 = SKSpriteNode(imageNamed: "RubberDuckie-Right-Orange.png")
    let rabbit1 = SKSpriteNode(imageNamed: "Rabbit-Right-White.png")
    let rabbit2 = SKSpriteNode(imageNamed: "Rabbit-Right-Pink.png")
    let rabbit3 = SKSpriteNode(imageNamed: "Rabbit-Right-Blue.png")
    let squirrel1 = SKSpriteNode(imageNamed: "Squirrel-Left-Brown.png")
    let squirrel2 = SKSpriteNode(imageNamed: "Squirrel-Left-Red.png")
    let squirrel3 = SKSpriteNode(imageNamed: "Squirrel-Left-Gray.png")
    
    let bulletHoleG1 = SKSpriteNode(imageNamed: "Bullet-Hole-Gray-1.png")
    let bulletHoleG2 = SKSpriteNode(imageNamed: "Bullet-Hole-Gray-2.png")
    let bulletHoleG3 = SKSpriteNode(imageNamed: "Bullet-Hole-Gray-3.png")
    let bulletHoleB1 = SKSpriteNode(imageNamed: "Bullet-Hole-Brown-1.png")
    let bulletHoleB2 = SKSpriteNode(imageNamed: "Bullet-Hole-Brown-2.png")
    let bulletHoleB3 = SKSpriteNode(imageNamed: "Bullet-Hole-Brown-3.png")

    var minutesString: String = "02"
    var secondsString: String = "00"
    var minutesInt: Int = 1
    var secondsInt: Int = 30
    var timeExpired: Bool = false
    var timer:Timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in})
    
    var gameOver = false
    var levelNumberValue: Int = 1
    var levelNumberString: String = "1"
    //var timerValue: Int = 120
    var timerString: String = "1:30"
    var scoreValue: Int = 0
    var scoreString: String = "0"
    var hitsValue: Int = 0
    var hitsString: String = "0"
    var missesValue: Int = 0
    var missesString: String = "0"
    
    var spriteSpeed: Double = 0.5

    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        var animation: Animation {
            Animation.easeOut
        }
        
        initializeBalloonPositionArrays()
        initializeScreenBasics()
        initializeCase1()
        initializeCase2()
        intializeBalloons()
        
        self.timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in
            self.decrementTime()
        })
    
        motionManager.startAccelerometerUpdates()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        textTimer.text = timerString
        rotateSpinningWheel()

    }
    
    func decrementTime() {
        if secondsInt == 0 && minutesInt == 0 {
            timeExpired = true
        }
        
        if timeExpired == true {
            gameOver = true
            self.timer.invalidate()
            lblGameOver.zPosition = 2
        }
        else {
            if secondsInt == 0 {
                secondsInt = 59
                if minutesInt > 0
                {
                    minutesInt = minutesInt - 1
                }
            }
            else {
                secondsInt = secondsInt - 1
            }
            
            minutesString = String(minutesInt)
            if secondsInt > 9 {
            secondsString = String(secondsInt)
            }
            else {
                secondsString = "0" + String(secondsInt)
            }
            timerString = minutesString + ":" + secondsString
            //print("Timer string:", timerString)
        }
    } // end of func decrementTime
    
    func rotateSpinningWheel() {
        spinningWheel.zRotation -= (spriteSpeed * (.pi/180))
    }
    
    func initializeBalloonPositionArrays() {
        // All of these numbers represent modifiers which are multiplied by screen
        // dimensions to achieve relative spacial positioning for the balloons.
        // As you can see, arrays in Swift are zero-based like C.
        let parentRadius = (frame.maxX / 3.8)
        balloonOriginalPositions[0][0] = (parentRadius * 0.997) - parentRadius
        balloonOriginalPositions[0][1] = (parentRadius * 1.32) - parentRadius
        balloonOriginalPositions[0][2] = 360.0
        balloonOriginalPositions[1][0] = (parentRadius * 1.19) - parentRadius
        balloonOriginalPositions[1][1] = (parentRadius * 1.259) - parentRadius
        balloonOriginalPositions[1][2] = 320.0
        balloonOriginalPositions[2][0] = (parentRadius * 1.312) - parentRadius
        balloonOriginalPositions[2][1] = (parentRadius * 1.097) - parentRadius
        balloonOriginalPositions[2][2] = 285.0
        balloonOriginalPositions[3][0] = (parentRadius * 1.312) - parentRadius
        balloonOriginalPositions[3][1] = (parentRadius * 0.903) - parentRadius
        balloonOriginalPositions[3][2] = 250.0
        balloonOriginalPositions[4][0] = (parentRadius * 1.195) - parentRadius
        balloonOriginalPositions[4][1] = (parentRadius * 0.736) - parentRadius
        balloonOriginalPositions[4][2] = 220.0
        balloonOriginalPositions[5][0] = (parentRadius * 1.0) - parentRadius
        balloonOriginalPositions[5][1] = (parentRadius * 0.672) - parentRadius
        balloonOriginalPositions[5][2] = 180.0
        balloonOriginalPositions[6][0] = (parentRadius * 0.805) - parentRadius
        balloonOriginalPositions[6][1] = (parentRadius * 0.736) - parentRadius
        balloonOriginalPositions[6][2] = 140.0
        balloonOriginalPositions[7][0] = (parentRadius * 0.702) - parentRadius
        balloonOriginalPositions[7][1] = (parentRadius * 0.914) - parentRadius
        balloonOriginalPositions[7][2] = 110.0
        balloonOriginalPositions[8][0] = (parentRadius * 0.708) - parentRadius
        balloonOriginalPositions[8][1] = (parentRadius * 1.097) - parentRadius
        balloonOriginalPositions[8][2] = 75.0
        balloonOriginalPositions[9][0] = (parentRadius * 0.814) - parentRadius
        balloonOriginalPositions[9][1] = (parentRadius * 1.259) - parentRadius
        balloonOriginalPositions[9][2] = 40.0

    }
    
    func initializeScreenBasics() {
        background.size = CGSize (width: frame.maxX, height: frame.maxY)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.name = "background"
        background.zPosition = 1
        addChild(background)
        
        gameTitle.text = "SHOOTING GALLERY ARCADE"
        gameTitle.fontSize = 90
        gameTitle.fontColor = SKColor.black
        gameTitle.horizontalAlignmentMode = .center
        gameTitle.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        gameTitle.zPosition = 2
        addChild(gameTitle)
        
        lblGameOver.text = "Game Over"
        lblGameOver.fontSize = 65
        lblGameOver.fontColor = SKColor.blue
        lblGameOver.horizontalAlignmentMode = .center
        lblGameOver.position = CGPoint(x: size.width * 0.5, y: size.height * 0.14)
        lblGameOver.zPosition = 0
        addChild(lblGameOver)
        
        lblLevel.text = "LEVEL"
        lblLevel.fontSize = 35
        lblLevel.fontColor = SKColor.black
        lblLevel.horizontalAlignmentMode = .center
        lblLevel.position = CGPoint(x: size.width * 0.135, y: size.height * 0.84)
        lblLevel.zPosition = 2
        addChild(lblLevel)
        
        textLevel.text = "01"
        textLevel.fontSize = 30
        textLevel.fontColor = SKColor.black
        textLevel.horizontalAlignmentMode = .center
        textLevel.position = CGPoint(x: size.width * 0.135, y: size.height * 0.8)
        textLevel.zPosition = 2
        addChild(textLevel)
        
        lblTimer.text = "TIMER"
        lblTimer.fontSize = 35
        lblTimer.fontColor = SKColor.black
        lblTimer.horizontalAlignmentMode = .center
        lblTimer.position = CGPoint(x: size.width * 0.31, y: size.height * 0.84)
        lblTimer.zPosition = 2
        addChild(lblTimer)
        
        textTimer.text = timerString
        textTimer.fontSize = 30
        textTimer.fontColor = SKColor.black
        textTimer.position = CGPoint(x: size.width * 0.31, y: size.height * 0.8)
        textTimer.zPosition = 2
        addChild(textTimer)
        
        lblScore.text = "SCORE"
        lblScore.fontSize = 45
        lblScore.fontColor = SKColor.black
        lblScore.horizontalAlignmentMode = .center
        lblScore.position = CGPoint(x: size.width * 0.5, y: size.height * 0.8396)
        lblScore.zPosition = 2
        addChild(lblScore)
        
        textScore.text = "00000"
        textScore.fontSize = 40
        textScore.fontColor = SKColor.blue
        textScore.horizontalAlignmentMode = .center
        textScore.position = CGPoint(x: size.width * 0.5, y: size.height * 0.796)
        textScore.zPosition = 2
        addChild(textScore)
        
        lblHits.text = "Hits"
        lblHits.fontSize = 35
        lblHits.fontColor = SKColor.black
        lblHits.horizontalAlignmentMode = .center
        lblHits.position = CGPoint(x: size.width * 0.69, y: size.height * 0.84)
        lblHits.zPosition = 2
        addChild(lblHits)
        
        textHits.text = "0000"
        textHits.fontSize = 30
        textHits.fontColor = SKColor.black
        textHits.horizontalAlignmentMode = .center
        textHits.position = CGPoint(x: size.width * 0.69, y: size.height * 0.8)
        textHits.zPosition = 2
        addChild(textHits)
        
        lblMisses.text = "Misses"
        lblMisses.fontSize = 35
        lblMisses.fontColor = SKColor.black
        lblMisses.horizontalAlignmentMode = .center
        lblMisses.position = CGPoint(x: size.width * 0.865, y: size.height * 0.84)
        lblMisses.zPosition = 2
        addChild(lblMisses)
        
        textMisses.text = "0000"
        textMisses.fontSize = 30
        textMisses.fontColor = SKColor.black
        textMisses.horizontalAlignmentMode = .center
        textMisses.position = CGPoint(x: size.width * 0.865, y: size.height * 0.8)
        textMisses.zPosition = 2
        addChild(textMisses)

    }
    
    func initializeCase1() {
        let screenWidth = frame.maxX
        let screenHeight = frame.maxY
        
        case1.removeAllChildren()
        
        case1.size = CGSize (width: screenWidth / 2.95, height: screenWidth / 2.7)
        case1.position = CGPoint(x: screenWidth * 0.17, y: (screenHeight / 2) - (screenHeight * 0.13))
        case1.name = "case1"
        case1.zPosition = 2
        addChild(case1)
        
        /*
        if let child1 = self.childNode(withName: "milkBottle1") as? SKSpriteNode {
                child1.removeFromParent()
        }
         */
        
        milkBottle1.size = CGSize (width: screenWidth / 48, height: screenWidth / 15)
        milkBottle1.position =  CGPoint(x: (case1.size.width / 2) * -0.665 , y: (case1.size.height / 2) * 0.56)
        milkBottle1.name = "milkBottle1"
        milkBottle1.zPosition = 3
        case1.addChild(milkBottle1)

        sodaCan1.size = CGSize (width: screenWidth / 48, height: screenWidth / 22)
        sodaCan1.position = CGPoint(x: (case1.size.width / 2) * -0.3325 , y: (case1.size.height / 2) * 0.5)
        sodaCan1.name = "sodaCan1"
        sodaCan1.zPosition = 3
        case1.addChild(sodaCan1)

        milkBottle2.size = CGSize (width: screenWidth / 48, height: screenWidth / 15)
        milkBottle2.position = CGPoint(x: (case1.size.width / 2) * -0.0 , y: (case1.size.height / 2) * 0.56)
        milkBottle2.name = "milkBottle2"
        milkBottle2.zPosition = 3
        case1.addChild(milkBottle2)

        sodaCan2.size = CGSize (width: screenWidth / 48, height: screenWidth / 22)
        sodaCan2.position = CGPoint(x: (case1.size.width / 2) * 0.3325 , y: (case1.size.height / 2) * 0.5)
        sodaCan2.name = "sodaCan2"
        sodaCan2.zPosition = 3
        case1.addChild(sodaCan2)

        milkBottle3.size = CGSize (width: screenWidth / 48, height: screenWidth / 15)
        milkBottle3.position = CGPoint(x: (case1.size.width / 2) * 0.665 , y: (case1.size.height / 2) * 0.56)
        milkBottle3.name = "milkBottle3"
        milkBottle3.zPosition = 3
        case1.addChild(milkBottle3)

        sodaCan3.size = CGSize (width: screenWidth / 48, height: screenWidth / 22)
        sodaCan3.position = CGPoint(x: (case1.size.width / 2) * -0.665 , y: (case1.size.height / 2) * -0.05)
        sodaCan3.name = "sodaCan3"
        sodaCan3.zPosition = 3
        case1.addChild(sodaCan3)

        milkBottle4.size = CGSize (width: screenWidth / 48, height: screenWidth / 15)
        milkBottle4.position = CGPoint(x: (case1.size.width / 2) * -0.3325 , y: (case1.size.height / 2) * 0.01)
        milkBottle4.name = "milkBottle4"
        milkBottle4.zPosition = 3
        case1.addChild(milkBottle4)

        sodaCan4.size = CGSize (width: screenWidth / 48, height: screenWidth / 22)
        sodaCan4.position = CGPoint(x: (case1.size.width / 2) * -0.0 , y: (case1.size.height / 2) * -0.05)
        sodaCan4.name = "sodaCan4"
        sodaCan4.zPosition = 3
        case1.addChild(sodaCan4)

        milkBottle5.size = CGSize (width: screenWidth / 48, height: screenWidth / 15)
        milkBottle5.position = CGPoint(x: (case1.size.width / 2) * 0.3325 , y: (case1.size.height / 2) * 0.01)
        milkBottle5.name = "milkBottle5"
        milkBottle5.zPosition = 3
        case1.addChild(milkBottle5)
        
        if let child10 = self.childNode(withName: "sodaCan5") as? SKSpriteNode {
                child10.removeFromParent()
        }
        sodaCan5.size = CGSize (width: screenWidth / 48, height: screenWidth / 22)
        sodaCan5.position = CGPoint(x: (case1.size.width / 2) * 0.665 , y: (case1.size.height / 2) * -0.05)
        sodaCan5.name = "sodaCan5"
        sodaCan5.zPosition = 3
        case1.addChild(sodaCan5)
        
        if let child11 = self.childNode(withName: "milkbottle6") as? SKSpriteNode {
                child11.removeFromParent()
        }
        milkBottle6.size = CGSize (width: screenWidth / 48, height: screenWidth / 15)
        milkBottle6.position = CGPoint(x: (case1.size.width / 2) * -0.665 , y: (case1.size.height / 2) * -0.55)
        milkBottle6.name = "milkBottle6"
        milkBottle6.zPosition = 3
        case1.addChild(milkBottle6)
        
        if let child12 = self.childNode(withName: "sodaCan6") as? SKSpriteNode {
                child12.removeFromParent()
        }
        sodaCan6.size = CGSize (width: screenWidth / 48, height: screenWidth / 22)
        sodaCan6.position = CGPoint(x: (case1.size.width / 2) * -0.3325 , y: (case1.size.height / 2) * -0.61)
        sodaCan6.name = "sodaCan6"
        sodaCan6.zPosition = 3
        case1.addChild(sodaCan6)
        
        if let child13 = self.childNode(withName: "milkbottle7") as? SKSpriteNode {
                child13.removeFromParent()
        }
        milkBottle7.size = CGSize (width: screenWidth / 48, height: screenWidth / 15)
        milkBottle7.position = CGPoint(x: (case1.size.width / 2) * -0.0 , y: (case1.size.height / 2) * -0.55)
        milkBottle7.name = "milkBottle7"
        milkBottle7.zPosition = 3
        case1.addChild(milkBottle7)
        
        if let child14 = self.childNode(withName: "sodaCan7") as? SKSpriteNode {
                child14.removeFromParent()
        }
        sodaCan7.size = CGSize (width: screenWidth / 48, height: screenWidth / 22)
        sodaCan7.position = CGPoint(x: (case1.size.width / 2) * 0.3325 , y: (case1.size.height / 2) * -0.61)
        sodaCan7.name = "sodaCan7"
        sodaCan7.zPosition = 3
        case1.addChild(sodaCan7)
        
        if let child15 = self.childNode(withName: "milkbottle8") as? SKSpriteNode {
                child15.removeFromParent()
        }
        milkBottle8.size = CGSize (width: screenWidth / 48, height: screenWidth / 15)
        milkBottle8.position = CGPoint(x: (case1.size.width / 2) * 0.665 , y: (case1.size.height / 2) * -0.55)
        milkBottle8.name = "milkBottle8"
        milkBottle8.zPosition = 3
        case1.addChild(milkBottle8)
    }
    
    func initializeCase2() {
        let screenWidth = frame.maxX
        let screenHeight = frame.maxY
        
        case2.removeAllChildren()
        
        case2.size = CGSize (width: screenWidth / 2.95, height: screenWidth / 2.7)
        case2.position = CGPoint(x: screenWidth - (screenWidth * 0.17), y: (screenHeight / 2) - (screenHeight * 0.13))
        case2.name = "case2"
        case2.zPosition = 2
        addChild(case2)
        
        print("Case2 Width:", case2.size.width)
        print("Case2 Height:", case2.size.height)
        
        rabbit1.size = CGSize (width: screenWidth / 24, height: screenWidth / 18)
        rabbit1.position = CGPoint(x: (case2.size.width / 2) * -0.65 , y: (case2.size.height / 2) * 0.6)
        rabbit1.name = "rabbit1"
        rabbit1.zPosition = 3
        case2.addChild(rabbit1)
        
        rabbit2.size = CGSize (width: screenWidth / 24, height: screenWidth / 18)
        rabbit2.position = CGPoint(x: (case2.size.width / 2) * 0.0 , y: (case2.size.height / 2) * 0.6)
        rabbit2.name = "rabbit2"
        rabbit2.zPosition = 3
        case2.addChild(rabbit2)
        
        rabbit3.size = CGSize (width: screenWidth / 24, height: screenWidth / 18)
        rabbit3.position = CGPoint(x: (case2.size.width / 2) * 0.65 , y: (case2.size.height / 2) * 0.6)
        rabbit3.name = "rabbit3"
        rabbit3.zPosition = 3
        case2.addChild(rabbit3)
        
        squirrel1.size = CGSize (width: screenWidth / 20, height: screenWidth / 22)
        squirrel1.position = CGPoint(x: (case2.size.width / 2) * -0.65, y: (case2.size.height / 2) * 0.115)
        squirrel1.name = "squirrel1"
        squirrel1.zPosition = 3
        case2.addChild(squirrel1)
        
        squirrel2.size = CGSize (width: screenWidth / 20, height: screenWidth / 22)
        squirrel2.position = CGPoint(x: (case2.size.width / 2) * 0.0 , y: (case2.size.height / 2) * 0.115)
        squirrel2.name = "squirrel2"
        squirrel2.zPosition = 3
        case2.addChild(squirrel2)
        
        squirrel3.size = CGSize (width: screenWidth / 20, height: screenWidth / 22)
        squirrel3.position = CGPoint(x: (case2.size.width / 2) * 0.65 , y: (case2.size.height / 2) * 0.115)
        squirrel3.name = "squirrel3"
        squirrel3.zPosition = 3
        case2.addChild(squirrel3)
        
        rubberDuckie1.size = CGSize (width: screenWidth / 20, height: screenWidth / 20)
        rubberDuckie1.position = CGPoint(x: (case2.size.width / 2) * -0.65, y: (case2.size.height / 2) * -0.53)
        rubberDuckie1.name = "rubberDuckie1"
        rubberDuckie1.zPosition = 3
        case2.addChild(rubberDuckie1)
        
        rubberDuckie2.size = CGSize (width: screenWidth / 20, height: screenWidth / 20)
        rubberDuckie2.position = CGPoint(x: (case2.size.width / 2) * -0.0, y: (case2.size.height / 2) * -0.53)
        rubberDuckie2.name = "rubberDuckie2"
        rubberDuckie2.zPosition = 3
        case2.addChild(rubberDuckie2)
        
        rubberDuckie3.size = CGSize (width: screenWidth / 20, height: screenWidth / 20)
        rubberDuckie3.position = CGPoint(x: (case2.size.width / 2) * 0.65, y: (case2.size.height / 2) * -0.53)
        rubberDuckie3.name = "rubberDuckie3"
        rubberDuckie3.zPosition = 3
        case2.addChild(rubberDuckie3)
    }
        
    func intializeBalloons() {
        let screenWidth = frame.maxX
        let screenHeight = frame.maxY
        
        spinningWheel.removeAllChildren()
        
        spinningWheel.size = CGSize (width: screenWidth / 3.8, height: screenWidth / 3.8)
        spinningWheel.position = CGPoint(x: screenWidth / 2, y: (screenHeight / 2) - (screenHeight * 0.1))
        spinningWheel.name = "spinningWheel"
        spinningWheel.zPosition = 2
        addChild(spinningWheel)
        
        target5.size = CGSize (width: screenWidth / 20, height: screenWidth / 20)
        target5.position = CGPoint(x: 0, y: 0)
        target5.name = "target5"
        target5.zPosition = 3
        spinningWheel.addChild(target5)
        
        target4.size = CGSize (width: screenWidth / 25, height: screenWidth / 25)
        target4.position = CGPoint(x: 0, y: 0)
        target4.name = "target4"
        target4.zPosition = 4
        spinningWheel.addChild(target4)
        
        target3.size = CGSize (width: screenWidth / 30, height: screenWidth / 30)
        target3.position = CGPoint(x: 0, y: 0)
        target3.name = "target3"
        target3.zPosition = 5
        spinningWheel.addChild(target3)
        
        target2.size = CGSize (width: screenWidth / 60, height: screenWidth / 60)
        target2.position = CGPoint(x: 0, y: 0)
        target2.name = "target2"
        target2.zPosition = 6
        spinningWheel.addChild(target2)
        
        target1.size = CGSize (width: screenWidth / 75, height: screenWidth / 75)
        target1.position = CGPoint(x: 0, y: 0)
        target1.name = "target1"
        target1.zPosition = 7
        spinningWheel.addChild(target1)
        
        balloon1.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon1.position = CGPoint(x: balloonOriginalPositions[0][0], y: balloonOriginalPositions[0][1])
        balloon1.name = "balloon1"
        balloon1.zRotation = balloonOriginalPositions[0][2] * .pi/180
        balloon1.zPosition = 3
        spinningWheel.addChild(balloon1)
        
        balloon2.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon2.position = CGPoint(x: balloonOriginalPositions[1][0], y: balloonOriginalPositions[1][1])
        balloon2.name = "balloon2"
        balloon2.zRotation = balloonOriginalPositions[1][2] * .pi/180
        balloon2.zPosition = 3
        spinningWheel.addChild(balloon2)
        
        balloon3.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon3.position = CGPoint(x: balloonOriginalPositions[2][0], y: balloonOriginalPositions[2][1])
        balloon3.name = "balloon3"
        balloon3.zRotation = balloonOriginalPositions[2][2] * .pi/180
        balloon3.zPosition = 3
        spinningWheel.addChild(balloon3)
        
        balloon4.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon4.position = CGPoint(x: balloonOriginalPositions[3][0], y: balloonOriginalPositions[3][1])
        balloon4.name = "balloon4"
        balloon4.zRotation = balloonOriginalPositions[3][2] * .pi/180
        balloon4.zPosition = 3
        spinningWheel.addChild(balloon4)
        
        balloon5.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon5.position = CGPoint(x: balloonOriginalPositions[4][0], y: balloonOriginalPositions[4][1])
        balloon5.name = "balloon5"
        balloon5.zRotation = balloonOriginalPositions[4][2] * .pi/180
        balloon5.zPosition = 3
        spinningWheel.addChild(balloon5)
        
        balloon6.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon6.position = CGPoint(x: balloonOriginalPositions[5][0], y: balloonOriginalPositions[5][1])
        balloon6.name = "balloon6"
        balloon6.zRotation = balloonOriginalPositions[5][2] * .pi/180
        balloon6.zPosition = 3
        spinningWheel.addChild(balloon6)
        
        balloon7.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon7.position = CGPoint(x: balloonOriginalPositions[6][0], y: balloonOriginalPositions[6][1])
        balloon7.name = "balloon7"
        balloon7.zRotation = balloonOriginalPositions[6][2] * .pi/180
        balloon7.zPosition = 3
        spinningWheel.addChild(balloon7)
        
        balloon8.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon8.position = CGPoint(x: balloonOriginalPositions[7][0], y: balloonOriginalPositions[7][1])
        balloon8.name = "balloon8"
        balloon8.zRotation = balloonOriginalPositions[7][2] * .pi/180
        balloon8.zPosition = 3
        spinningWheel.addChild(balloon8)
        
        balloon9.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon9.position = CGPoint(x: balloonOriginalPositions[8][0], y: balloonOriginalPositions[8][1])
        balloon9.name = "balloon9"
        balloon9.zRotation = balloonOriginalPositions[8][2] * .pi/180
        balloon9.zPosition = 3
        spinningWheel.addChild(balloon9)
    
        balloon10.size = CGSize (width: screenWidth / 30, height: screenWidth / 25)
        balloon10.position = CGPoint(x: balloonOriginalPositions[9][0], y: balloonOriginalPositions[9][1])
        balloon10.name = "balloon10"
        balloon10.zRotation = balloonOriginalPositions[9][2] * .pi/180
        balloon10.zPosition = 3
        spinningWheel.addChild(balloon10)
    }
}
