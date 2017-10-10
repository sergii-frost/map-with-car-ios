//
//  CarAnnotation.swift
//  MapWithCar
//
//  Created by Sergii Frost on 2017-10-09.
//  Copyright © 2017 Frosted AB. All rights reserved.
//

import Foundation
import MapKit

public class CarAnnotation: MKPointAnnotation {
    
    var direction: CLLocationDirection?
    
    override public init() {
        super.init()
        self.title = "Car"
    }
}
