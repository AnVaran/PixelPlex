//
//  LocationManager.swift
//  Pixel
//
//  Created by Admin on 11/6/20.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let location = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var completion: ((String) -> Void)?
    private var completionIsDenied: ((Bool) -> Void)?
    
    override init() {
        super.init()
        checkUserLocation()
    }
    
    private func checkUserLocation() {
        location.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            location.delegate = self
            location.desiredAccuracy = kCLLocationAccuracyBest
            location.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { (placemark, error) in
                if error == nil {
                    guard let placemark = placemark?.last else { return }
                    if let country = placemark.country {
                    self.completion?(country)
                    }
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        completionIsDenied?(false)
        if status == CLAuthorizationStatus.denied {
            completionIsDenied?(true)
        } else {
            completionIsDenied?(false)
        }
    }
    
    func getLocationCountry(complition: ((String) -> Void)?) {
        self.completion = complition
    }
    
    func getLocationIsDenied(complition: ((Bool) -> Void)?) {
        self.completionIsDenied = complition
    }
}
