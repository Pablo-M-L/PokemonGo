//
//  PokemonAnnotation.swift
//  PokemonGo
//
//  Created by admin on 15/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotation:NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon

    init(coordinate: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinate
        self.pokemon = pokemon
    }

    
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
