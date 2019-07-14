//
//  ViewController.swift
//  PokemonGo
//
//  Created by admin on 14/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    
    var updateCount = 0
    let mapDistance: CLLocationDistance = 300
    
    @IBAction func updateUserLocation(_ sender: UIButton) {
        //limita la region a mostrar.
        if let coordinate = self.manager.location?.coordinate{
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: mapDistance, longitudinalMeters: mapDistance)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation() //actualiza la posicion si hay movimiento, y llama a locationManager.
            
        }else{
            self.manager.requestWhenInUseAuthorization()

        }
        
        
       


    }

    
    
    //MARK: Core location manager delegate.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateCount < 4 {
            //limita la region a mostrar.
            if let coordinate = self.manager.location?.coordinate{
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: mapDistance, longitudinalMeters: mapDistance)
                self.mapView.setRegion(region, animated: true)
                
                updateCount += 1
            }

        }
        else{
            self.manager.stopUpdatingLocation() // el punto se sigue moviendo, al parar deja de llamar a este metodo.
        }

    }

}

