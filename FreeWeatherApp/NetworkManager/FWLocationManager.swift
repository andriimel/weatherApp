//
//  LocationManager.swift
//  FreeWeatherApp
//
//  Created by Andrii Melnyk on 4/28/24.
//

import UIKit
import CoreLocation

protocol FWWeaterLocationDelegate : AnyObject {
    func getMyCurrentLocation(with location: String)
}

class LocationManager : NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    var delegate : FWWeaterLocationDelegate?
    
    var locationManager = CLLocationManager()
    
    let geocoder = CLGeocoder()
    var location: CLLocation?

    public func getCurrentLocation() {
   
        locationManager.requestAlwaysAuthorization()
     
            locationManager.distanceFilter = 1000.0
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            locationManager.stopUpdatingLocation()
    
    }

    // MARK: - Location

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("i was here !!!!!!! ")
//        if locationManager.authorizationStatus == .authorizedWhenInUse {
        guard let location = locations.first else {return}
        self.location = location
        locationManager.stopUpdatingLocation()
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [self] (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            guard let placemarks = placemarks else {return}
            let placemark = placemarks as [CLPlacemark]
            if placemark.count>0{
                
                let placemark = placemarks[0]
                self.delegate?.getMyCurrentLocation(with: placemark.subLocality!)
            
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("When user did not yet determined")
        case .restricted:
            print("Restricted by parental control")
        case .denied:
            print("When user select option Dont't Allow")
        case .authorizedAlways:
            print("When user select option Change to Always Allow")
            getCurrentLocation()
        case .authorizedWhenInUse:
            print("When user select option Allow While Using App or Allow Once")
          getCurrentLocation()
        default:
            print("default")
        }
    }
}
