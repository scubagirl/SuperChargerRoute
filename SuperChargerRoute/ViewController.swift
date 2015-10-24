//
//  ViewController.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 6/26/15.
//  Copyright (c) 2015 Lauren OKeefe. All rights reserved.
//

import UIKit
import MapKit
import Parse
//import TFHpple

class ViewController: UIViewController {
    
    var locationManager: LocationManager!
    var regionRad: CLLocationDistance!
    var stations: [SuperChargerStation] = []
    var names: [String] = []
    
    let testObject = PFObject(className: "TestObject")
    
    @IBOutlet weak var outputLabel: UILabel! = nil
    @IBOutlet weak var mapView: MKMapView!
    
    //TODO: Hook This up!!!!!
    @IBAction func mapTypeChanged(sender: AnyObject) {
        switch (sender.selectedSegmentIndex){
        
            case 0:
                mapView.mapType = MKMapType.Standard
            
            case 1:
                mapView.mapType = MKMapType.Satellite
            
            case 2:
                mapView.mapType = MKMapType.Hybrid
            
            default:
                mapView.mapType = MKMapType.Standard
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = LocationManager()
        locationManager.checkLocationServices()
        regionRad = locationManager.regionRadius
        centerMapOnLocation(locationManager.usCenter)
        let currentLocation = MKPointAnnotation()
        currentLocation.coordinate = locationManager.getCoord()
        //TODO: Make current location a different color
        self.mapView.addAnnotation(currentLocation)
        
        getSuperChargerData()
        mapView.addAnnotations(stations)
        
        /****** Test Code ******/
//        outputLabel.hidden = true
//        outputLabel.font = UIFont.boldSystemFontOfSize(20.0)
//         outputLabel.text = "lat:\(locationManager.getCoord().latitude), long:\(locationManager.getCoord().longitude)"
//        
//        testObject["foo"] = "bar"
//        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//            println("Object has been saved.")
//        }
        
    }
    
    


    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRad * 2.0, regionRad * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    /* Get the URL for individual charger stations and return: [String] */
    func getSuperChargerURLs()->[NSArray]{
        var stationURLS = [NSArray]()
        let url = NSURL(string: "http://www.teslamotors.com/findus/list/superchargers/United+States")
        let data = NSData(contentsOfURL: url!)
        let dataParser = TFHpple(HTMLData: data)
        if let elements = dataParser.searchWithXPathQuery("//a[starts-with(@href,'/findus/location/supercharger/')]") {
            for element in elements {
                let name = element.content
                let rawElement = element.raw.description
                let interumString = rawElement.substringFromIndex(rawElement.startIndex.advancedBy(9))
                let finalString = interumString.substringToIndex(interumString.characters.indexOf("\"")!)
                let nameSite = [name, finalString]
                stationURLS.append(nameSite)

            }
        }
        
        return stationURLS
    }
    
    func getSuperChargerData(){
        let stationArray = getSuperChargerURLs()
        var coordinate = CLLocationCoordinate2D()
        
        for stationURL in stationArray {
            let url = NSURL(string: "http://www.teslamotors.com\(stationURL[1])")
            let data = NSData(contentsOfURL: url!)
            let dataParser = TFHpple(HTMLData: data)
            
            /* Set SuperCharger Name */
            let name = stationURL[0] as! String
            
            
            /* Find SuperCharger Coordinates */
            if let elements = dataParser.searchWithXPathQuery("//a[starts-with(@href,'https://maps.google.com/maps?daddr=')]") {
                for element in elements {
                    let rawElement = element.raw.description
                    let interumString = rawElement.substringFromIndex(rawElement.startIndex.advancedBy(44))
                    let latLongString = interumString.substringToIndex(interumString.characters.indexOf("\"")!)
                    let latLongArray = latLongString.componentsSeparatedByString(",")
                    
                    coordinate.latitude = Double(latLongArray[0])!
                    coordinate.longitude = Double(latLongArray[1])!
                }
            }
            else if let elements = dataParser.searchWithXPathQuery("//img[starts-with(@src,'https://maps.googleapis.com/maps/api/staticmap?scale=2&center=')]") {
                for element in elements {
                    let rawElement = element.raw.description
                    let interumString = rawElement.substringFromIndex(rawElement.startIndex.advancedBy(62))
                    let latLongString = interumString.substringToIndex(interumString.characters.indexOf("\"")!)
                    let latLongArray = latLongString.componentsSeparatedByString(",")
                    
                    coordinate.latitude = Double(latLongArray[0])!
                    coordinate.longitude = Double(latLongArray[1])!
                }
            }
            
            let station = SuperChargerStation(name: name, coordinate: coordinate)
            print(station.name, station.coordinate.latitude, station.coordinate.longitude)
            stations.append(station)
        }
    }
    
    func plotSuperChargerStations(){
        
    }

}

