//
//  PokemoTableViewController.swift
//  PokemonGo
//
//  Created by admin on 15/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PokemoTableViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var caughtPokemons: [Pokemon] = []
    var uncaughtPokemons: [Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        caughtPokemons = getAllCaughtPokemon()
        uncaughtPokemons = getAllUncaughtPokemon()
        print(caughtPokemons.count)
        print(uncaughtPokemons.count)    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "capturados"
        }
        else{
            return "no capturados"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            print("capturados - \(self.caughtPokemons.count)")
            return self.caughtPokemons.count
            
        }
        else{
            print(" sin capturados - \(self.uncaughtPokemons.count)")
            return self.uncaughtPokemons.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonCellTableViewCell
        var pokemon: Pokemon
        if indexPath.section == 0{
            pokemon = self.caughtPokemons[indexPath.row]
            cell.labelInf.text = "\(pokemon.timesCaught) veces capturado"
        }
        else{
            pokemon = self.uncaughtPokemons[indexPath.row]
            cell.labelInf.text = "Sin capturar"
        }
        
        cell.labelSup.text = pokemon.name
        cell.imagenPokemon.image = UIImage(named: pokemon.imageFileName!)
        
        return cell
    }
}
