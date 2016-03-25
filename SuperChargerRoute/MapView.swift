//
//  MapView.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 1/13/16.
//  Copyright © 2016 Lauren OKeefe. All rights reserved.
//

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
    
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == annotationView.rightCalloutAccessoryView {
            self.performSegueWithIdentifier("mapToInfo", sender: annotationView)
        }
    

    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let selectedAnnotation = view.annotation
        for annotation in mapView.annotations {
            if annotation.isEqual(selectedAnnotation){
                if(startSelected == true){
                    self.directionsView.start.text = annotation.title!
                }
                else if(endSelected == true){
                    self.directionsView.end.text = annotation.title!
                }
            }
        }
    }
    
    

    
    

}