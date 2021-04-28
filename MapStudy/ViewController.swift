//
//  ViewController.swift
//  MapStudy
//
//  Created by admin on 26.02.2021.
//  Copyright © 2021 admin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

@IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
            super .viewDidAppear(animated)
            checkLocationEnabled()
    }
 
    func setupManager() {
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
      }
    
    func checkAutorization() {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        case .denied:
            showAlertLocation(title: "Включен запрет на использование местоположения", message: "Включить?", url: URL(string: UIApplication.openSettingsURLString))
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default: break
    
        }
    }
    
    func showAlertLocation (title:String,message:String?,url:URL?) {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
             
             let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (alert) in
                 if let url = url {
                     UIApplication.shared.open(url, options:[:], completionHandler: nil)
                 }
         }
             let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
             alert.addAction(settingsAction)
             alert.addAction(cancelAction)
             present(alert, animated: true, completion: nil)
     }
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled(){
           setupManager()
            checkAutorization()
        } else {
        showAlertLocation(title:"У вас выключена служба геолокации", message: "Включить?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
}
    extension ViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last?.coordinate {
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
                mapView.setRegion(region, animated: true)
            }
        }
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            checkAutorization()
        }
      }

