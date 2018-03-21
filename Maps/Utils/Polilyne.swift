//
//  Polilyni.swift
//  Maps
//
//  Created by Bodya on 20.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import Foundation
import GoogleMaps

class Polilyne {
    
    static func polilyne(with path: GMSPath) -> GMSPolyline {
        let polilyne = GMSPolyline(path: path)
        polilyne.strokeWidth = 5
        return polilyne
    }
    
}
