//
//  InfoView.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 1/14/16.
//  Copyright © 2016 Lauren OKeefe. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import GoogleMaps


class InfoView: UIViewController, UIScrollViewDelegate{

    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var addressInfo: UILabel!
    @IBOutlet weak var localityInfo: UILabel!
    @IBOutlet weak var stallInfo: UILabel!
    @IBOutlet weak var typeInfo: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var localMapView: MKMapView!
    
    var superCharger: SuperChargerStation!
    var annotation: MKAnnotation!
    var locationManager: LocationManager!
    var regionRad: CLLocationDistance!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if locationManager == nil {
            locationManager = LocationManager()
            locationManager.checkLocationServices()
        }
        regionRad = locationManager.regionRadius
        centerMapOnLocation(CLLocation(latitude:superCharger.coordinate.latitude, longitude: superCharger.coordinate.longitude))
        let superChargerLocation = MKPointAnnotation()
        superChargerLocation.coordinate = superCharger.coordinate
        localMapView.addAnnotation(superChargerLocation)

        
        if (superCharger != nil) {
            self.navItem.title = superCharger.name
            self.addressInfo.text = superCharger.address
            self.localityInfo.text = superCharger.locality
            self.stallInfo.text = superCharger.stalls
            self.typeInfo.text = superCharger.types
            self.latitude.text = "Latitude: \(superCharger.coordinate.latitude)"
            self.longitude.text = "Longitude: \(superCharger.coordinate.longitude)"
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "infoToStreet"{
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            if let streetView:StreeView = destinationNavigationController.topViewController as? StreeView{
                    streetView.superCharger = superCharger
                    streetView.locationManger = locationManager
                
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRad * 0.0001, regionRad * 0.0001)
        localMapView.setRegion(coordinateRegion, animated: true)
    }

}