//
//  SettingsView.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 3/24/16.
//  Copyright © 2016 Lauren OKeefe. All rights reserved.
//

import UIKit
import MapKit


class SettingsView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var delegate: SettingsViewDelegate?
    var mapView: MKMapView!
    var model: String!
    var range: Int!
    var superCharger: SuperChargerStation!
    var centerCoord: CLLocationCoordinate2D!
    var teslaModels = ["Model S: 60", "Model S: 85/P85D/85+/85P", "Roadster"]
    var modelRange = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func mapChanger(sender: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex{
            
        case 0: self.mapView.mapType = MKMapType.Standard
        case 1: self.mapView.mapType = MKMapType.Hybrid
        case 2: self.mapView.mapType = MKMapType.Satellite
        default: self.mapView.mapType = MKMapType.Standard
        }
    }
    
    @IBOutlet weak var customRange: UITextField!
    

    @IBAction func customRangeFinishedEditing(sender: AnyObject) {
        let customRangeInt = Int(customRange.text!)
        if(customRangeInt != nil){
            self.delegate?.updateRange(customRangeInt!)
        }
    }
    @IBOutlet weak var vehiclePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vehiclePicker.delegate = self
        self.vehiclePicker.dataSource = self
        self.customRange.text = "\(range)"
        
        if(model != nil && model != ""){
            let selectedRow = teslaModels.indexOf(model)
            self.vehiclePicker.selectRow(selectedRow!, inComponent: 0, animated: true)
        }
        
        switch mapView.mapType{
        case MKMapType.Standard: segmentedControl.selectedSegmentIndex = 0
        case MKMapType.Hybrid: segmentedControl.selectedSegmentIndex = 1
        case MKMapType.Satellite: segmentedControl.selectedSegmentIndex = 2
        default: segmentedControl.selectedSegmentIndex = 0
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teslaModels.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return teslaModels[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.updateModel(teslaModels[row])
        let localRange = self.modelRange[row][1] as! Int
        self.range = localRange
        self.customRange.text = "\(localRange)"
        
        
    }
    
}

protocol  SettingsViewDelegate {
    func updateModel(model: String)
    func updateRange(range: Int)
}
