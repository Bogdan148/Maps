//
//  GoogleMapsView.swift
//  Maps
//
//  Created by Bodya on 18.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsView: UIView, GMSMapViewDelegate {
    
    var googleMap = GMSMapView()
    var polilyne = GMSPolyline()
    var isAnimatingCar = false
    
    private let locationManager = CLLocationManager()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 10)
        googleMap = GMSMapView.map(withFrame: self.frame, camera: camera)
        googleMap.delegate = self
        googleMap.isMyLocationEnabled = true
        googleMap.settings.myLocationButton = true
        self.addSubview(googleMap)
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        googleMap.frame = self.bounds
    }
    
    func addMarker(position: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: position)
        marker.map = googleMap
        googleMap.animate(toLocation: position)
    }
    
    func writePolilyne(polilyne: GMSPolyline) {
        self.polilyne.map = nil
        self.polilyne = polilyne
        self.polilyne.map = googleMap
    }
    
    func setupWithRoute(route: Route) {
        googleMap.clear()
        if route.origin != nil {
            addMarker(position: CLLocationCoordinate2D(latitude: route.origin.latitude,
                                                       longitude: route.origin.longitude))
        }
        for location in route.waypoints {
            addMarker(position: CLLocationCoordinate2D(latitude: location.latitude,
                                                       longitude: location.longitude))
        }
        if route.destination != nil {
        addMarker(position: CLLocationCoordinate2D(latitude: route.destination.latitude,
                                                   longitude: route.destination.longitude))
        }
    }
    
    func animateCar(marker: GMSMarker,forPath path: GMSPath, complition: @escaping () -> Void) {
        if isAnimatingCar == false {
            marker.position = path.coordinate(at: 0)
            marker.rotation = GMSGeometryHeading(path.coordinate(at: 0), path.coordinate(at: 1))
            marker.map = googleMap
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            animateToEndOfPath(path: path, fromIndex: 1, marker: marker, complition: complition)
            isAnimatingCar = true
        }
    }
    
    private func animateToEndOfPath(path: GMSPath,
                                    fromIndex index: UInt,
                                    marker: GMSMarker,
                                    complition: @escaping () -> Void) -> Void {
        let coord = path.coordinate(at: index)
        let previous = marker.position
        marker.rotation = GMSGeometryHeading(previous, coord)
        let distance = GMSGeometryDistance(previous, coord)
        
        CATransaction.begin();
        let duration = Double(distance / 500)
        CATransaction.setAnimationDuration(duration)
        CATransaction.setCompletionBlock { [weak self] in
            if index < path.count() - 1 {
                self?.animateToEndOfPath(path: path, fromIndex: index + 1, marker: marker, complition: complition)
            } else {
                self?.isAnimatingCar = false
                marker.map = nil
                complition()
            }
        }
        marker.position = coord;
        
        CATransaction.commit()
    }
    
}

extension GoogleMapsView: CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            googleMap.animate(toLocation: location.coordinate)
            manager.stopUpdatingLocation()
        }
    }
}
