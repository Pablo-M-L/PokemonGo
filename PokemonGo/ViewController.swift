//
//  ViewController.swift
//  PokemonGo
//
//  Created by admin on 14/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    
    var updateCount = 0
    let mapDistance: CLLocationDistance = 200
    
    var pokemonSpawnTimer: TimeInterval = 5
    
    var pokemons: [Pokemon] = []
    
    @IBAction func updateUserLocation(_ sender: UIButton) {
        //limita la region a mostrar.
        if let coordinate = self.manager.location?.coordinate{
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: mapDistance, longitudinalMeters: mapDistance)
            self.mapView.setRegion(region, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemons = getAllThePokemon()
        
        self.manager.delegate = self
        

        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            self.mapView.delegate = self
            self.mapView.showsUserLocation = true
            self.manager.startUpdatingLocation() //actualiza la posicion si hay movimiento, y llama a locationManager.
            

            Timer.scheduledTimer(withTimeInterval: pokemonSpawnTimer, repeats: true) { (timer) in
                print("temp")
                if let coordinate = self.manager.location?.coordinate{ //obtiene las coordenadas del usuario.
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500.0) / 300000.0
                    annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500.0) / 300000.0
                    self.mapView.addAnnotation(annotation)
                    print("crear anotacion  -\(annotation.coordinate.latitude) -- \(annotation.coordinate.longitude)")
                }
                
                
            }
            
            
            
            
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
    
        //MARK: mapview manager delegate.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        
        if annotation is MKUserLocation{
            annotationView.image = UIImage(named: "player") //para que no ponga un pokemmon en la localizacion del usuario.
        }
        else{
            annotationView.image = UIImage(named: "abra")
        }
        
        
        var reducedFrame = annotationView.frame
        reducedFrame.size.height = 40
        reducedFrame.size.width = 40
        annotationView.frame = reducedFrame
        return annotationView
    }

}

