//
//  MapView.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 1/13/16.
//  Copyright © 2016 Lauren OKeefe. All rights reserved.
//

import Foundation
import MapKit

extension ViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? SuperChargerStation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let button = UIButton(type: .DetailDisclosure)
                view.rightCalloutAccessoryView = button as UIView
            }
            view.pinTintColor = UIColor.greenColor()
            return view
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mapToInfo"{
            let destinationNavigationController = segue.destinationViewController as! UINavigationController
            if let infoView: InfoView = destinationNavigationController.topViewController as? InfoView{
                
                let annotation = (sender as! MKAnnotationView).annotation!
                if let supercharger = annotation as? SuperChargerStation{
                    infoView.superCharger = supercharger
                    infoView.locationManager = locationManager
                }
                
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            self.performSegueWithIdentifier("mapToInfo", sender: annotationView)
        }

    }
    
    

}