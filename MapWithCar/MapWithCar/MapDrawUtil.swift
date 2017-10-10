//
//  MapDrawUtil.swift
//  MapWithCar
//
//  Created by Sergii Frost on 2017-10-09.
//  Copyright © 2017 Frosted AB. All rights reserved.
//

import Foundation
import MapKit

public class MapDrawUtil {
    
    private static let kEdgeInset: CGFloat = 50
    
    private init() {
        //Avoid public instantiation
    }
    
    static func drawRoute(in mapView: MKMapView, forLocations locations: [CLLocation], shouldDrawCar: Bool = true) {
        //1. clean all old routes
        mapView.overlays.filter { (overlay: MKOverlay) -> Bool in
            return overlay is MKGeodesicPolyline
            }.forEach { (overlay: MKOverlay) in
                mapView.remove(overlay)
        }
        
        //2. draw new route
        let coordinates = locations.map { (location: CLLocation) -> CLLocationCoordinate2D in
            location.coordinate
        }
        let route: MKGeodesicPolyline = MKGeodesicPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.add(route)
        
        //3. draw car
        if !shouldDrawCar {
            return
        }
        drawCar(in: mapView, forLocations: locations)
    }
    
    static func centerFit(mapView: MKMapView, locations: [CLLocation]) {
        var zoomRect: MKMapRect = MKMapRectNull
        locations.map { location -> CLLocationCoordinate2D in
            return location.coordinate
            }.forEach { coordinate in
                let point = MKMapPointForCoordinate(coordinate)
                let pointRect = MKMapRectMake(point.x, point.y, 0, 0)
                if (MKMapRectIsNull(zoomRect)) {
                    zoomRect = pointRect
                } else {
                    zoomRect = MKMapRectUnion(zoomRect, pointRect)
                }
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsetsMake(kEdgeInset, kEdgeInset, kEdgeInset, kEdgeInset), animated: true)
    }
    
    static func drawCar(in mapView: MKMapView, forLocations locations: [CLLocation]) {
        if locations.isEmpty {
            return
        }
        
        mapView.annotations.filter { annotation -> Bool in
            return annotation is CarAnnotation
            }.forEach { annotation in
                mapView.removeAnnotation(annotation)
        }
        
        let carAnnotation = CarAnnotation()
        if let lastLocation = locations.last {
            carAnnotation.coordinate = lastLocation.coordinate
        }
        if locations.count >= 2 {
            carAnnotation.direction = locations[locations.count - 2].bearing(to: locations.last)
        }
        mapView.addAnnotation(carAnnotation)
    }

}
