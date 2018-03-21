//
//  RouteManager.swift
//  Maps
//
//  Created by Bodya on 21.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import Foundation
import GoogleMaps

class RouteManager {
    
    private init() {}
    static let shared = RouteManager()
    
    let persistanceService = PersistanceService.shared
    var representRoute = Route()
    
    func newRepresentRoute() {
        representRoute = Route()
    }
    
    func saveRoute(route: Route) {
        if route.origin != nil || route.destination != nil {
            persistanceService.update(object: route)
        }
    }
    
    func deleteRoute(route: Route) {
        persistanceService.delete(object: route)
    }
    
    func allSavedRoutes () -> [Route] {
        return Array(PersistanceService.shared.realm.objects(Route.self))
    }
    
    func directionFor(route: Route,
                      complition : @escaping (_ path : GMSPath, _ polilyne: GMSPolyline) -> Void,
                      failure : @escaping () -> Void) {
        GoogleDirectionApiService().getDirection(route: route, complition: { (path) in
            DispatchQueue.main.async {
                complition(path, Polilyne.polilyne(with: path))
            }
        },failure: failure)
    }
}
