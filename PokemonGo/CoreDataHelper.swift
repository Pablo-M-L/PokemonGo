//
//  CoreDataHelper.swift
//  PokemonGo
//
//  Created by admin on 15/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import CoreData


func createAllThePokemon(){
    
    //crear pokemons
    createPokemon(name: "Abra", imageNamed: "abra",frequency: 80)
    createPokemon(name: "Bellsprout", imageNamed: "bellsprout",frequency: 70)
    createPokemon(name: "Caterpie", imageNamed: "caterpie", frequency: 100)
    createPokemon(name: "Bullbasaur", imageNamed: "bullbasaur",frequency: 30)
    createPokemon(name: "Jigglypuff", imageNamed: "jigglypuff",frequency: 50)
    createPokemon(name: "Meowth", imageNamed: "meowth",frequency: 50)
    createPokemon(name: "Pikachu-2", imageNamed: "pikachu-2",frequency: 20)
    
    //guardar pokemons creados
     (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
}

func createPokemon(name: String, imageNamed: String, frequency: Int){
    //devuelve el delegado del proyecto. y en el, al persistentContainer.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.name = name
    pokemon.imageFileName = imageNamed
    pokemon.frequency = Int16(frequency)
}

func getAllThePokemon()->[Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do{
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0{
            createAllThePokemon()
            return getAllThePokemon()
        }
        return pokemons
    }catch{
        print("error coredata")
    }
    return []
}

func getAllCaughtPokemon()->[Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught > %d", 0)
    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
        
        if pokemons.count == 0{
            createAllThePokemon()
            return getAllCaughtPokemon()
        }
        return pokemons
    }catch{
        print("error coredata caught")
    }
    return []
}

func getAllUncaughtPokemon()->[Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "timesCaught == %d", 0)

    do{
        let pokemons = try context.fetch(fetchRequest) as [Pokemon]
    
        return pokemons
    }catch{
        print("error coredata uncaught")
    }
    return []
}
