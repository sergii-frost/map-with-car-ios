//
//  RandomExt.swift
//  MapWithCar
//
//  Created by Sergii Frost on 2017-10-10.
//  Copyright © 2017 Frosted AB. All rights reserved.
//

import Foundation
import MapKit

// MARK: CLLocation Extension

extension CLLocation {
    
    
    /// Generate new random location within distance and bearing
    ///
    /// - Parameters:
    ///   - distanceMeters: distance in meters
    ///   - bearingDegrees: bearing in degrees in range 0..360.0
    /// - Returns: new location with specified distance and bearing
    func location(byMovingDistance distanceMeters: Double, withBearing bearingDegrees: CLLocationDirection) -> CLLocation {
        let distanceRadians: Double = distanceMeters / 6372797.6
        // earth radius in meters
        let bearingRadians = Double(bearingDegrees * .pi / 180)
        let lat1 = coordinate.latitude * .pi / 180
        let lon1 = coordinate.longitude * .pi / 180
        let lat2 = asin(sin(lat1) * cos(distanceRadians) + cos(lat1) * sin(distanceRadians) * cos(bearingRadians))
        let lon2 = lon1 + atan2(sin(bearingRadians) * sin(distanceRadians) * cos(lat1), cos(distanceRadians) - sin(lat1) * sin(lat2))
        return CLLocation(latitude: lat2 * 180 / .pi, longitude: lon2 * 180 / .pi)
    }
}

// MARK: Double Extension

public extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random double between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random double point number between 0 and n max
    public static func random(min: Double, max: Double) -> Double {
        return Double.random * (max - min) + min
    }
}
