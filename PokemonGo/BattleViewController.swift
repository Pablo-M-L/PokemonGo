//
//  BattleViewController.swift
//  PokemonGo
//
//  Created by admin on 16/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SpriteKit

class BattleViewController: UIViewController {

    var pokemonBVC: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = BattleScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view = SKView()
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        scene.scaleMode = .aspectFill
        scene.pokemon = self.pokemonBVC
        skView.presentScene(scene)
        
        //notificacion fin batalla
        NotificationCenter.default.addObserver(self, selector: #selector(returnToMapViewController), name: NSNotification.Name("closeBattle"), object: nil)
    }
    
    @objc func returnToMapViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
