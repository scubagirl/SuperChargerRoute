//
//  InfoView.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 1/14/16.
//  Copyright © 2016 Lauren OKeefe. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps


class InfoView: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var addressInfo: UILabel!
    @IBOutlet weak var localityInfo: UILabel!
    @IBOutlet weak var stallInfo: UILabel!
    @IBOutlet weak var typeInfo: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var localMapView: MKMapView!
    @IBOutlet weak var streetViewButton: UIButton!
    
    var superCharger: SuperChargerStation!
    var annotation: MKAnnotation!
    var locationManager: LocationManager!
    var regionRad: CLLocationDistance!
    var mapSnapshot: MKMapSnapshotter!
    var delegate: InfoViewDelegate?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.streetViewButton.setTitle("", forState: .Disabled)
        self.streetViewButton.setTitle("Street View", forState: .Normal)
        self.streetViewButton.enabled = false
        let streetViewCheck = GMSPanoramaService()
        streetViewCheck.requestPanoramaNearCoordinate(superCharger.coordinate) { (pano:GMSPanorama!, error: NSError!) -> Void in
            if((error) == nil){
                self.streetViewButton.enabled = true
            }
            
        }
        
        if (superCharger != nil) {
            self.title = superCharger.name
            self.addressInfo.text = superCharger.address
            self.localityInfo.text = superCharger.locality
            self.stallInfo.text = superCharger.stalls
            self.typeInfo.text = superCharger.types
            self.latitude.text = "Latitude: \(superCharger.coordinate.latitude)"
            self.longitude.text = "Longitude: \(superCharger.coordinate.longitude)"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate?.setSegueBool(true)
        self.delegate?.setSuperCharger(superCharger)
        
        if locationManager == nil {
            locationManager = LocationManager()
            locationManager.checkLocationServices()
        }
        regionRad = locationManager.regionRadius
        centerMapOnLocation(superCharger.location)
        let superChargerLocation = MKPointAnnotation()
        superChargerLocation.coordinate = superCharger.coordinate
        localMapView.addAnnotation(superChargerLocation)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "infoToStreet"{
            if let streetView:StreeView = segue.destinationViewController as? StreeView{
                    streetView.superCharger = superCharger
                    streetView.locationManger = locationManager
                
            }
        }
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRad * 0.0002, regionRad * 0.0002)
        localMapView.setRegion(coordinateRegion, animated: true)
    }

}

protocol InfoViewDelegate{
    func setSegueBool(segueBool: Bool)
    func setSuperCharger(superCharger: SuperChargerStation)
}