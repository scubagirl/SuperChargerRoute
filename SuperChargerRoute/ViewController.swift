//
//  ViewController.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 6/26/15.
//  Copyright (c) 2015 Lauren OKeefe. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
    var locationManager: LocationManager!
    var regionRad: CLLocationDistance!
    var stations: [SuperChargerStation] = []
    var names: [String] = []
    
    
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
        mapView.delegate = self
        locationManager = LocationManager()
        locationManager.checkLocationServices()
        regionRad = locationManager.regionRadius
        centerMapOnLocation(locationManager.getLocation())
        let currentLocation = MKPointAnnotation()
        currentLocation.coordinate = locationManager.getCoord()
        self.mapView.addAnnotation(currentLocation)
        getSuperChargerData()
        mapView.addAnnotations(stations)
        
    }

    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRad * 2.0, regionRad * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getSuperChargerData(){
        let data = getJSON("http://www.supercharger.laurencokeefe.com/super_charger_data.json")
        let jsonObj = JSON(data: data)
        if jsonObj != JSON.null {
            let jsonStations = jsonObj["stations"]
            for (key, subJson) in jsonStations {
                let name = key
                var coordinate = CLLocationCoordinate2D()
                coordinate.latitude = subJson["lat"].doubleValue
                coordinate.longitude = subJson["lng"].doubleValue
                let address = subJson["address"].stringValue
                let locality = subJson["locality"].stringValue
                let stalls = subJson["stalls"].stringValue
                let types = subJson["types"].stringValue
                
                let station = SuperChargerStation(name: name, coordinate: coordinate, address: address, locality: locality, stalls: stalls, types: types)
                stations.append(station)
            }
        } else {
            print("could not get json from file, make sure that file contains valid json.")
        }
    }
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    

}

