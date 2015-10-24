//
//  LocationManager.swift
//  SpeedLimit
//


import Foundation
import CoreLocation

/* Class for determining location */
class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    var regionRadius: CLLocationDistance = 2400000
    let usCenter: CLLocation = CLLocation(latitude: 38.828328, longitude: -96.579416)
    
    /* Initiallize CLLocationManager*/
    override init(){
        super.init()
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 10.0
        manager.activityType = .AutomotiveNavigation
        manager.delegate = self
    }
    
    /* Start ability of updating of location */
    func startUpdatingLocation() {
        
        manager.delegate = self;
        manager.startUpdatingLocation()
        
    }
    
    /* Authorize the app to use location services */
    func checkLocationServices() {
        switch CLLocationManager.authorizationStatus() {
            
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            
            startUpdatingLocation()
            
        default:
            
            manager.delegate = self
            manager.requestAlwaysAuthorization()
            startUpdatingLocation()
        }
    }
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        print("locations = \(locations)")
        //      NSThread.sleepForTimeInterval(0.001)
    }
    
    
    /* Get coordinates - return invalid (lat = -180, long = -180) if location not available */
//    func getCoord() ->CLLocation {
//        if(manager.location != nil){
//            return manager.location
//        }
//        
//        return CLLocation(latitude: 39.828328, longitude: -98.579416)
//    }
    func getCoord() ->CLLocationCoordinate2D {
        if(manager.location != nil){
            return manager.location!.coordinate
        }
        
        return CLLocationCoordinate2DMake(39.828328,-98.579416)
    }
    
}
