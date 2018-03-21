//
//  GoogleDirectionApiService.swift
//  Maps
//
//  Created by Bodya on 19.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class GoogleDirectionApiService {
    
    let networkService = NetworkService(Constants.googleDirectionApiURL)
    
    func getDirection(route: Route,
                      complition : @escaping (_ path : GMSPath) -> Void,
                      failure : @escaping () -> Void) -> Void {
        let origin = "\(route.origin.latitude),\(route.origin.longitude)"
        let destination = "\(route.destination.latitude),\(route.destination.longitude)"
        var waypoints = ""
        for location in route.waypoints {
            waypoints += "\(location.latitude),\(location.longitude)|"
        }
        let parameters = [URLQueryItem(name: "origin", value:origin),
                          URLQueryItem(name: "destination", value:destination),
                          URLQueryItem(name: "waypoints", value: waypoints),
                          URLQueryItem(name: "key", value:Constants.googleDirectionApiKey)]
        networkService.getRequest(parameters: parameters) { (data) in
            guard let path = self.parsePath(from: data) else {
                failure()
                return
            }
            complition(path)
        }
    }
    
    private func parsePath(from data: Data) -> GMSPath? {
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
        print("\(String(describing: json))")
        guard json!["status"] as! String == "OK" else {
            return nil
        }
        let routes = json!["routes"] as! [[String : Any]]
        let route = routes.last
        let routeOverviewPolyline = route!["overview_polyline"] as! [String : String]
        let points = routeOverviewPolyline["points"]
        guard let path = GMSPath(fromEncodedPath: points!) else {
            return nil
        }
        return path

    }
}
