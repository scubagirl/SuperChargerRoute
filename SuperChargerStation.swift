//
//  SuperChargerStation.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 10/22/15.
//  Copyright © 2015 Lauren OKeefe. All rights reserved.
//

import MapKit

class SuperChargerStation: NSObject, MKAnnotation {
    var name: String?
    let coordinate: CLLocationCoordinate2D
    var address: String?
    var locality: String?
    var stalls: String?
    var types: String?
    var location: CLLocation

    
    init(name: String, coordinate:CLLocationCoordinate2D, address: String, locality: String, stalls:String,
        types: String
        ){
            self.name = name
            self.coordinate = coordinate
            self.address = address
            self.locality = locality
            self.stalls = stalls
            self.types = types
            self.location = CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)

            
        super.init()
    }
    
    var title: String? {
        return name
    }
    
}
