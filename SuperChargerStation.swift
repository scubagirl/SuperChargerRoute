//
//  SuperChargerStation.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 10/22/15.
//  Copyright © 2015 Lauren OKeefe. All rights reserved.
//

import Foundation
import MapKit

class SuperChargerStation: NSObject, MKAnnotation {
    var name: String?
    let coordinate: CLLocationCoordinate2D
    
    init(name: String, coordinate:CLLocationCoordinate2D){
        self.name = name
        self.coordinate = coordinate
        
        super.init()
    }
    
    var title: String? {
        return name
    }
}
