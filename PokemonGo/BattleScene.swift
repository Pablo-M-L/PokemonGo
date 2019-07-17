//
//  BattleScene.swift
//  PokemonGo
//
//  Created by admin on 16/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import SpriteKit
import UIKit

class  BattleScene: SKScene, SKPhysicsContactDelegate {
    
    var pokemon: Pokemon!
    var pokemonSprite: SKNode!
    var pokeballSprite: SKNode!
    
    let kPokemonSize: CGSize = CGSize(width: 65, height: 65)
    let kPokemonName: String = "pokemon"
    let kPokeballName: String = "pokeball"
    
    var kPokemonDistance: CGFloat = 0.0
    let kPokemonPixelPerSecond: CGFloat = 60.0
    
    //categorias de choque
    let kPokemonCategory: UInt32 = 0x1 << 0
    let kPokeballCategory: UInt32 = 0x1 << 1
    let kSceneEdgeCategory: UInt32 = 0x1 << 2

    //lanzar pokeball
    var velocity: CGPoint = CGPoint.zero
    var touchPoint: CGPoint = CGPoint()
    var canThrowPokeball = false
    var pokemonCaught = false
    
    var startCount = true
    var maxTime = 20
    var myTime = 20
    var printTime = SKLabelNode(fontNamed: "arial")
    
    
    override func didMove(to view: SKView) {
        
        kPokemonDistance = (self.frame.width/2) - 35
        
        //añadir fondo
        let bgImage = SKSpriteNode(imageNamed: "background")
        bgImage.size = self.size
        bgImage.position = CGPoint(x: self.frame.minX, y: self.frame.minY)
        bgImage.anchorPoint = CGPoint.zero
        bgImage.zPosition = -1
        self.addChild(bgImage)
     
        //añadir label
        self.printTime.verticalAlignmentMode = .top
        self.printTime.fontColor = UIColor.red
        self.printTime.fontSize = 72
        self.printTime.position = (CGPoint(x: self.frame.midX, y: self.frame.maxY - 50.0))
        addChild(printTime)
        
        //mostrar imagen de batalla
        let message = SKSpriteNode(imageNamed: "battle")
        message.size = CGSize(width: 150, height: 150)
        message.position = (CGPoint(x: self.frame.midX, y: self.frame.midY - 50.0))
        addChild(message)
        
        message.run(SKAction.sequence([SKAction.wait(forDuration: 3.0), SKAction.removeFromParent()]))
        
        //retardo al mostrar pokemon y pokeball
        self.perform(#selector(setupPokemon), with: nil, afterDelay: 2.0)
        self.perform(#selector(setupPokeball), with: nil, afterDelay: 1.0)
        
        //fisicas
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = kSceneEdgeCategory
        self.physicsWorld.contactDelegate = self

    }
     
    
    func createPokemon()-> SKNode{
        let pokemonSprite = SKSpriteNode(imageNamed: self.pokemon.imageFileName!)
        pokemonSprite.size = kPokemonSize
        pokemonSprite.name = kPokemonName
        return pokemonSprite
        
    }
    
    @objc func setupPokemon(){

        self.pokemonSprite = self.createPokemon()
        self.pokemonSprite.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //fisicas
        self.pokemonSprite.physicsBody = SKPhysicsBody(rectangleOf: kPokemonSize)
        self.pokemonSprite.physicsBody!.isDynamic = false
        self.pokemonSprite.physicsBody!.affectedByGravity = false
        self.pokemonSprite.physicsBody!.mass = 1
        
        self.pokemonSprite.physicsBody!.categoryBitMask = kPokemonCategory
        self.pokemonSprite.physicsBody!.contactTestBitMask = kPokeballCategory
        self.pokemonSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory
        
        
        let moveRight = SKAction.moveBy(x: self.kPokemonDistance, y: 0.0, duration: TimeInterval(kPokemonDistance / kPokemonPixelPerSecond))
        let sequence = SKAction.sequence([moveRight, moveRight.reversed(),moveRight.reversed(),moveRight])
        self.pokemonSprite.run(SKAction.repeatForever(sequence))

        
        self.addChild(self.pokemonSprite)
    }
    
    func createPokeball()-> SKNode{
        let PokeballSprite = SKSpriteNode(imageNamed: "pokeball")
        PokeballSprite.size = kPokemonSize
        PokeballSprite.name = kPokeballName
        return PokeballSprite
        
    }
    
    @objc func setupPokeball(){
        self.pokeballSprite = self.createPokeball()
        self.pokeballSprite.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 50)
        
        //fisicas
        self.pokeballSprite.physicsBody = SKPhysicsBody(circleOfRadius: self.pokeballSprite.frame.size.width/2.0)
        self.pokeballSprite.physicsBody!.isDynamic = true
        self.pokeballSprite.physicsBody!.affectedByGravity = true
        self.pokeballSprite.physicsBody!.mass = 0.1
        
        self.pokeballSprite.physicsBody!.categoryBitMask = kPokeballCategory
        self.pokeballSprite.physicsBody!.contactTestBitMask = kPokemonCategory
        self.pokeballSprite.physicsBody!.collisionBitMask = kSceneEdgeCategory | kPokemonCategory
        
        self.addChild(self.pokeballSprite)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch?.location(in: self)
        if self.pokeballSprite.frame.contains(location!){
            self.canThrowPokeball = true
            self.touchPoint = location!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        self.touchPoint = location!
        if canThrowPokeball{
            self.throwPokeball()
        }
    }
    
    func throwPokeball(){
        self.canThrowPokeball = false
        let dt: CGFloat = 1.0/20.0
        let distance = CGVector(dx: self.touchPoint.x - self.pokeballSprite.position.x, dy: self.touchPoint.y - self.pokeballSprite.position.y)
        let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
        self.pokeballSprite.physicsBody!.velocity = velocity
        
    }


    func didBegin(_ contact: SKPhysicsContact) {
        let contactMsk = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMsk {
        case kPokemonCategory|kPokeballCategory:
            self.pokemonCaught = true
            endGame()
        default:
            return
        }
    }

    override func update(_ currentTime: TimeInterval) {
        //inicializa la cuenta atras
        if self.startCount{
            maxTime = Int(currentTime) + self.maxTime
            self.startCount = false
        }
    
        self.myTime = self.maxTime - Int(currentTime)
        self.printTime.text = "\(self.myTime)"
        if self.myTime <= 2{
            endGame()
        }
     

    }
    
    
    @objc func endGame(){
        self.pokemonSprite.removeFromParent()
        self.pokeballSprite.removeFromParent()
        
        if pokemonCaught{
            self.pokemon.timesCaught += 1
            
            pokemonCaught = false
            (UIApplication.shared.delegate as! AppDelegate).saveContext() //guardamos en el core data

           
            //mostrar imagen de capturado
            let message = SKSpriteNode(imageNamed: "gotcha")
            message.size = CGSize(width: 150, height: 150)
            message.position = (CGPoint(x: self.frame.midX, y: self.frame.midY - 50.0))
            addChild(message)
            
            message.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()]))
            
        }else{
            //mostrar imagen de fin tiempo
            let message = SKSpriteNode(imageNamed: "footprints")
            message.size = CGSize(width: 150, height: 150)
            message.position = (CGPoint(x: self.frame.midX, y: self.frame.midY - 50.0))
            addChild(message)
            
            message.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.removeFromParent()]))
            
        }
        
        self.perform(#selector(endBattle), with: nil, afterDelay: 2.0)

        
    }

    @objc func endBattle(){
        NotificationCenter.default.post(name: NSNotification.Name("closeBattle"),object: nil)
    }



}
