//
//  MyLocationManager.swift
//  MapWithCar
//
//  Created by Sergii Frost on 2017-10-09.
//  Copyright © 2017 Frosted AB. All rights reserved.
//

import Foundation
import MapKit

protocol MyLocationManagerDelegate {
    func didUpdateUserLocation(location: CLLocation?);
}

public class MyLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = MyLocationManager()
    var delegate: MyLocationManagerDelegate?
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.activityType = .other
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        return locationManager
    }()
    
    public func currentUserLocation() -> CLLocation? {
        return locationManager.location
    }
    
    override private init() {
        //Avoid public init
        super.init()
    }
    
    func checkLocationPermission() {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingHeading()
    }

    
    //MARK: Location Manager Delegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdateUserLocation(location: currentUserLocation())
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
        
}
