//
//  LocationExt.swift
//  MapWithCar
//
//  Created by Sergii Frost on 2017-10-10.
//  Copyright © 2017 Frosted AB. All rights reserved.
//

import Foundation
import MapKit

extension CLLocation {
    func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    func bearing(to location: CLLocation?) -> CLLocationDegrees {
        guard let location = location else {
            return -1
        }
        let lat1 = degreesToRadians(degrees: self.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: self.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: location.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: location.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        let result = radiansToDegrees(radians: radiansBearing)
        return result
    }
}
