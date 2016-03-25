//
//  StreetView.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 1/14/16.
//  Copyright © 2016 Lauren OKeefe. All rights reserved.
//

import MapKit
import GoogleMaps

class StreeView: UIViewController, GMSMapViewDelegate {
    
    
    var superCharger: SuperChargerStation!
    var locationManger: LocationManager!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = superCharger.title
        
        let panoView = GMSPanoramaView(frame: CGRectZero)
        panoView.backgroundColor = UIColor.clearColor()
        panoView.moveNearCoordinate(superCharger.coordinate)
        self.view = panoView

        
    }
        
}