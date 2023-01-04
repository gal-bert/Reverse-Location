//
//  ViewController.swift
//  Reverse Location
//
//  Created by Gregorius Albert on 04/01/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var manager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        manager?.requestWhenInUseAuthorization()
        manager?.startUpdatingLocation()
        
        
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let first = locations.first else {return}
        print("\(first.coordinate.latitude) | \(first.coordinate.longitude)")
        
        // Async and reactive update
        lookUpCurrentLocation { placemark in
            print("\(placemark?.name ?? "No name")")
        }
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                               -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.manager?.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
}

