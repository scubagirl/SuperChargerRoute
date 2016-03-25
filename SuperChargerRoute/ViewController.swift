//
//  ViewController.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 6/26/15.
//  Copyright (c) 2015 Lauren OKeefe. All rights reserved.
//

import UIKit
import MapKit



class ViewController: UIViewController, UITextFieldDelegate{
    
    var locationManager: LocationManager!
    var regionRad: CLLocationDistance!
    var stations: [SuperChargerStation] = []
    var names: [String] = []
    var segueBoolian = false
    var segueStation: SuperChargerStation!
    var startLocation: String!
    var endLocation: String!
    var selectedAnnotaion: MKAnnotation!
    var textField: UITextField!
    var startSelected = false
    var endSelected = false
    var model = "Model S: 60"
    var range = 160
    var modelRange = [["Model S: 60", 160], ["Model S: 85/P85D/85+/85P/85D", 200], ["Roadster", 200]]
    
    @IBOutlet weak var directionsView: DirectionsView!

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func currentLocationButton(sender: AnyObject) {
        centerMapOnLocation(locationManager.getLocation())
    }
    

    @IBAction func createRoute(sender: AnyObject) {
        if(self.directionsView.hidden == false){
            self.directionsView.hidden = true
        }
        else{
            self.directionsView.hidden = false
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.directionsView.start.addTarget(self, action: #selector(ViewController.startDidBeginEditing), forControlEvents: UIControlEvents.EditingDidBegin)
        
        self.directionsView.start.addTarget(self, action: #selector(ViewController.startDidEndEditing), forControlEvents: UIControlEvents.EditingDidEnd)
        
        self.directionsView.end.addTarget(self, action: #selector(ViewController.endDidBeginEditing), forControlEvents: UIControlEvents.EditingDidBegin)
        
        self.directionsView.end.addTarget(self, action: #selector(ViewController.endDidEndEditing), forControlEvents: UIControlEvents.EditingDidEnd)
        
        
        loadDirectionView()
        
        self.title = "Super Charger Stations"
        mapView.delegate = self
        locationManager = LocationManager()
        locationManager.checkLocationServices()
        regionRad = locationManager.regionRadius
        
        if segueBoolian == false{
            centerMapOnLocation(locationManager.getLocation())
        }
        else{
            centerMapOnLocation(segueStation.location)
            segueBoolian = false
        }
      
        let currentLocation = MKPointAnnotation()
        currentLocation.coordinate = locationManager.getCoord()
        currentLocation.title = "Current Location"
        self.mapView.addAnnotation(currentLocation)
        getSuperChargerData()
        mapView.addAnnotations(stations)
        
        
        
    }
    func startDidBeginEditing(textField: UITextField){
        startSelected = true
        textFieldDidBeginEditing(textField)
    }
    
    func endDidBeginEditing(textField: UITextField){
        endSelected = true
        textFieldDidBeginEditing(textField)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if(mapView.selectedAnnotations.count > 0){
            if(mapView.selectedAnnotations[0].isKindOfClass(SuperChargerStation)){
                let currentSelection = mapView.selectedAnnotations[0] as! SuperChargerStation
                textField.text = currentSelection.name
            }
            else{
                textField.text = "Current Location"
            }
            
            
        }
        
    }

    
    func startDidEndEditing(textField: UITextField) {
        startSelected = false
        
    }
    
    func endDidEndEditing(textField: UITextField) {
        endSelected = false
        
    }
    

    func loadDirectionView(){
        self.directionsView.hidden = true
        self.view.bringSubviewToFront(directionsView)
        self.directionsView.start.leftView = self.directionsView.startLabel
        self.directionsView.start.leftViewMode = UITextFieldViewMode.Always
        self.directionsView.end.leftView = self.directionsView.endLabel
        self.directionsView.end.leftViewMode = UITextFieldViewMode.Always
        self.directionsView.start.text = "Current Location. Click pin to change."
        self.directionsView.end.text = "Click Supercharger pin to change."
    }

    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRad * 1.0, regionRad * 1.0)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mainToSettings"{
            if let settingsView: SettingsView = segue.destinationViewController as? SettingsView{
                settingsView.mapView = self.mapView
                settingsView.model = self.model
                settingsView.range = self.range
                settingsView.modelRange = self.modelRange
                (segue.destinationViewController as! SettingsView).delegate = self
            }
        }
        if segue.identifier == "mapToInfo"{
            if let infoView: InfoView = segue.destinationViewController as? InfoView{
                
                let annotation = (sender as! MKAnnotationView).annotation!
                if let supercharger = annotation as? SuperChargerStation{
                    infoView.superCharger = supercharger
                    infoView.locationManager = locationManager
                    (segue.destinationViewController as! InfoView).delegate = self
                }
                
            }
        }
    }
    
}

extension ViewController: SettingsViewDelegate {
    func updateModel(model: String) {
        self.model = model
    }
    
    func updateRange(range: Int){
        self.range = range
    }
}

extension ViewController: InfoViewDelegate{
    func setSegueBool(segueBool: Bool) {
        self.segueBoolian = segueBool
    }
    func setSuperCharger(superCharger: SuperChargerStation){
        self.segueStation = superCharger
    }
}

