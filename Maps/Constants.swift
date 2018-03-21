//
//  Constans.swift
//  Maps
//
//  Created by Bodya on 18.03.2018.
//  Copyright © 2018 Bodya. All rights reserved.
//

import Foundation

enum Constants {
    static let googleMapsApiKey = "AIzaSyC52zgl3IB1r5wzVjaTNJaKnPz1LDf4txM"
    static let googlePlacesApiKey = "AIzaSyCg7LBVAs96BqYLt96cErTh5pwFPT02nkA"
    static let googleDirectionApiKey = "AIzaSyBkOO0JZXiGVQ76GEE_IjlfScgisw1dskM"
    
    static let googleDirectionApiURL = "https://maps.googleapis.com/maps/api/directions/json"
    
    static let mainVCCell = "mainVCCell"
    static let allRoutesVCCell = "allRoutesVCCell"
    
    static let mainVCOriginBtText = "Origin destination"
    static let mainVCArrivalBtText = "Arrival destinatoin"
    static let mainVCOtherBtText = "Other destination"
    static let mainVCAlert = "You need choose origin and arrival destination"
    static let mainVCAlertWaipoint = "Waypoints can not be more than 5"
    static let mainVCDirectionFailure = "Can`t build route"
}
