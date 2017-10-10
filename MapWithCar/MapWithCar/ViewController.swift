//
//  ViewController.swift
//  MapWithCar
//
//  Created by Sergii Frost on 2017-10-06.
//  Copyright © 2017 Frosted AB. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MyLocationManagerDelegate {
    
    private let kCarAnnotationReuseId = "CarAnnotation"

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        MyLocationManager.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MyLocationManager.shared.checkLocationPermission()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        MyLocationManager.shared.stopUpdatingLocation()
    }
    
    // MARK: MyLocationManagerDelegate
    
    func didUpdateUserLocation(location: CLLocation?) {
        if !CarLocationService.shared.hasLocations() {
            resetCarLocation()
        }
    }
    
    @IBAction func updateCarLocation() {
        if let _ = CarLocationService.shared.getCarLocation() {
            MapDrawUtil.drawRoute(in: mapView, forLocations: CarLocationService.shared.locations)
        }
        MapDrawUtil.centerFit(mapView: mapView, locations: CarLocationService.shared.locations)
    }
    
    @IBAction func resetCarLocation() {
        if let location = MyLocationManager.shared.currentUserLocation() {
            mapView.setCenter(location.coordinate, animated:true)
            CarLocationService.shared.resetToLocation(location: location)
            updateCarLocation()
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKGeodesicPolyline {
            return renderer(forPolyline: overlay as! MKGeodesicPolyline)
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is CarAnnotation {
            return view(mapView, forCar: annotation as! CarAnnotation)
        }
        return nil
    }
    
    private func renderer(forPolyline polyline: MKGeodesicPolyline) -> MKOverlayRenderer {        
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.orange
        renderer.lineWidth = 2
        return renderer
    }
    
    private func view(_ mapView: MKMapView, forCar carAnnotation: CarAnnotation) -> CarAnnotationView {
        var carView: CarAnnotationView
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: kCarAnnotationReuseId) as? CarAnnotationView {
            carView = view
        } else {
            carView = CarAnnotationView(annotation: carAnnotation, reuseIdentifier: kCarAnnotationReuseId)
        }
        carView.annotation = carAnnotation
        carView.direction = carAnnotation.direction
        return carView
    }
    
}
