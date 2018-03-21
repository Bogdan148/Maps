//
//  Location.swift
//  Maps
//
//  Created by Bodya on 19.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

@objcMembers class Location: Object {
    dynamic var latitude: Double = 0
    dynamic var longitude: Double = 0
    dynamic var name: String = ""
    
    convenience init(_ coordinate: CLLocationCoordinate2D, _ locationName: String) {
        self.init()
        latitude = coordinate.latitude
        longitude = coordinate.longitude
        name = locationName
    }
}
