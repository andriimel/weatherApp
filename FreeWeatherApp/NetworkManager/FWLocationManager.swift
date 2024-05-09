//
//  LocationManager.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/28/24.
//

import UIKit
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    static let shared = LocationManager()
    let geocoder = CLGeocoder()
    private var locationFetchCompletion: ((CLLocation) -> Void)?

     var location: CLLocation? {
        didSet {
            guard let location else {
                return
            }
            locationFetchCompletion?(location)
        }
    }

    public func getCurrentLocation(completion: @escaping (CLLocation) -> Void) {

        self.locationFetchCompletion = completion
       
       
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000.0
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
    }

    // MARK: - Location

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        print("i was here !!!!!!! ")
        
        guard let location = locations.first else {return}
        self.location = location
        locationManager.stopUpdatingLocation()
        print(location)

    }

}
