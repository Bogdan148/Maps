//
//  CarMarker.swift
//  Maps
//
//  Created by Bodya on 21.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import UIKit
import GoogleMaps

class CarMarker: GMSMarker {
    
    override init() {
        super.init()
        self.icon = UIImage(named: "car")
    }
}
