//
//  Route.swift
//  Maps
//
//  Created by Bodya on 18.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Route: Object {
    dynamic var key = ""
    dynamic var origin: Location! {
        didSet {
            compoundKey()
        }
    }
    dynamic var destination: Location! {
        didSet {
            compoundKey()
        }
    }
    dynamic var waypoints = List<Location>()
   
    override class func primaryKey() -> String? {
        return "key"
    }
    
    func addWaypoint(location: Location) {
        waypoints.append(location)
        compoundKey()
    }
    
    func removeWaypoint(atIndex: Int) {
        waypoints.remove(at: atIndex)
        compoundKey()
    }
    
    func compoundKey() {
        var str = String()
        if origin != nil {
            str = str + origin.name
        }
        for location in waypoints {
            str = str + location.name
        }
        if destination != nil {
            str = str + destination.name
        }
        key = str
    }

}
