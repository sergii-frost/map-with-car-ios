//
//  CarLocationService.swift
//  MapWithCar
//
//  Created by Sergii Frost on 2017-10-09.
//  Copyright © 2017 Frosted AB. All rights reserved.
//

import Foundation
import MapKit

public class CarLocationService {
    
    private static let kDistanceMeters: Double = 100.0
    private static let kMaxBearing: CLLocationDirection = 360.0
    
    static let shared = CarLocationService()
    
    lazy var locations: [CLLocation] = []
    
    private init() {
        //Avoid public init
    }
    
    public func resetToLocation(location: CLLocation) {
        locations.removeAll()
        locations.append(location)
    }
    
    public func hasLocations() -> Bool {
        return !locations.isEmpty
    }
    
    public func getCarLocation() -> CLLocation? {
        if let last = locations.last, let next = generateNextCarLocation(for: last) {
            locations.append(next)
            return next
        }
        return nil
    }
    
    private func generateNextCarLocation(for lastCarLocation: CLLocation) -> CLLocation? {
        let maxBearing = CarLocationService.kMaxBearing / Double(locations.count % 3 + 1) //For more random bearings
        return lastCarLocation.location(byMovingDistance: Double.random(min: 0, max: CarLocationService.kDistanceMeters), withBearing: Double.random(min: 0, max: maxBearing))
    }
}
