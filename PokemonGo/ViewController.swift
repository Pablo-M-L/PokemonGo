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
    var hasStartedTheMap = false
    
    var updateCount = 0
    let mapDistance: CLLocationDistance = 150
    let captureDistance: CLLocationDistance = 100

    var pokemonSpawnTimer: TimeInterval = 5
    
    var pokemons: [Pokemon] = []
    
    var sumaTotalFrequency = 0
    var hasMovedToAntherView = false
    var timer: Timer!
    
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
        
        
        //suma todas las frequency
        for p in self.pokemons{
            sumaTotalFrequency += Int(p.frequency)
        }
        
        self.manager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setUpMap()
        }else{
            self.manager.requestWhenInUseAuthorization()

        }
    }
    
    override func viewWillDisappear(_ animated: Bool){
        self.timer.invalidate()
        self.hasMovedToAntherView = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.hasMovedToAntherView{
            self.starTimer()

        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            setUpMap()
        }
    }
    
    func setUpMap(){
    if !hasStartedTheMap{
        
        self.hasStartedTheMap = true
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.manager.startUpdatingLocation() //actualiza la posicion si hay movimiento, y llama a locationManager.
    
        self.starTimer()
        
    
        }
    }

    func starTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: pokemonSpawnTimer, repeats: true, block: { (timer) in
            if let coordinate = self.manager.location?.coordinate{ //obtiene las coordenadas del usuario.
                
                //let annotation = MKPointAnnotation()
                //annotation.coordinate = coordinate
                
                let randomNumber = Int(arc4random_uniform(UInt32(self.sumaTotalFrequency)))
                
                var pokemonFrequencyAcumuladas = 0
                var pokemonRandom: Pokemon = self.pokemons[0]
                for p in self.pokemons{
                    pokemonRandom = p
                    pokemonFrequencyAcumuladas += Int(p.frequency)
                    if pokemonFrequencyAcumuladas >= randomNumber{
                        break
                    }
                    
                }
                
                //let randomPos = Int(arc4random_uniform(UInt32(self.pokemons.count)))
                //let pokemonRandom = self.pokemons[randomPos]
                
                let annotation = PokemonAnnotation(coordinate: coordinate, pokemon: pokemonRandom)
                annotation.coordinate.latitude += (Double(arc4random_uniform(1000)) - 500.0) / 300000.0
                annotation.coordinate.longitude += (Double(arc4random_uniform(1000)) - 500.0) / 300000.0
                self.mapView.addAnnotation(annotation)
            }
            
            
        })
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
            let pokemonRandomPasadoPorParametro = (annotation as! PokemonAnnotation).pokemon
            annotationView.image = UIImage(named: pokemonRandomPasadoPorParametro.imageFileName!)
        }
        
        
        var reducedFrame = annotationView.frame
        reducedFrame.size.height = 40
        reducedFrame.size.width = 40
        annotationView.frame = reducedFrame
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        //una vez esta seleccionado no deja volver a seleccionarlo, por eso le mandamos deseleccionarlo para poder volver a seleccionarlo.
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        //evitamos que se pueda selecionar el player.
        if view.annotation is MKUserLocation{
            return
            
        }
        
        //crea una region de mapa con las coordenadas de la anotacion (que es el pokemon) como centro y el tamaño indicado.
        let region = MKCoordinateRegion(center: view.annotation!.coordinate, latitudinalMeters: captureDistance, longitudinalMeters: captureDistance)
        //pasamos esa region al mapView
        self.mapView.setRegion(region, animated: true)
        
        
        //obtiene las coordenadas del dispositivo y comprueba si está dentro de la region alrededor del pokemon.
        if let coordinate = self.manager.location?.coordinate{
            let mkmapPoint = MKMapPoint(coordinate)
            let mkRect: MKMapRect = self.mapView.visibleMapRect
            let regionRectPokemon = mkRect.contains(mkmapPoint)
            
            if regionRectPokemon{
                let vc = BattleViewController()
                vc.pokemonBVC = (view.annotation! as! PokemonAnnotation).pokemon
                self.mapView.removeAnnotation(view.annotation!)
                self.present(vc,animated: true, completion: nil)
            }
            else{
                let pokemos = (view.annotation! as! PokemonAnnotation).pokemon
                let alertController = UIAlertController(title: "estas demasiado lejos!!!", message: "acercate al \(pokemos.name) para capturarlo", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }

        
        
        
    }


}


