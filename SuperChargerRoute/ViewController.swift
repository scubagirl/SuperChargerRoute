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
    
    let testObject = PFObject(className: "TestObject")
    
    @IBOutlet weak var outputLabel: UILabel! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = LocationManager()
        locationManager.checkLocationServices()
        regionRad = locationManager.regionRadius
        centerMapOnLocation(locationManager.usCenter)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationManager.getCoord()
        self.mapView.addAnnotation(annotation)
        println("lat: \(annotation.coordinate.latitude)  long: \(annotation.coordinate.longitude)")
        
        getSuperChargerStations()
        
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
    
    

    @IBOutlet weak var mapView: MKMapView!
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRad * 2.0, regionRad * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func getSuperChargerStations(){
        let url = NSURL(string: "http://www.teslamotors.com/findus/list/superchargers/United+States")
        let request = NSURLRequest(URL: url!)
//        var contents = String(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)
        
        let data = NSData(contentsOfURL: url!)
        var dataParser = TFHpple(HTMLData: data)
        if let elements = dataParser.searchWithXPathQuery("//a[starts-with(@href,'/findus/location/supercharger/')]") {
            for element in elements {
                let rawElement = element.raw.description
                let start = advance(rawElement.startIndex, 9)
                let interumString = rawElement.substringFromIndex(start)
                println(interumString)

                
            }
        }
//        println(dataParser.data)
        
//        println(contents)
//        var pages: [String] = []

        var indicies = [Int]()
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            var string = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            var searchRange = NSMakeRange(0,string!.length)
            var foundRange: NSRange!
            while (searchRange.location < string!.length) {
                searchRange.length = string!.length-searchRange.location;
                foundRange = searchRange
                if (foundRange.location != NSNotFound) {
                    indicies.append(foundRange.location)
                    searchRange.location = foundRange.location+foundRange.length;
                } else {
                    break;
                }
            }
            
        }
        print(indicies)
    }

}

