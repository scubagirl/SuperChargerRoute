//
//  DirectionsView.swift
//  SuperChargerRoute
//
//  Created by Lauren OKeefe on 3/22/16.
//  Copyright © 2016 Lauren OKeefe. All rights reserved.
//

import UIKit


class DirectionsView: UIView{
  
    @IBOutlet weak var start: UITextField!
    @IBOutlet weak var end: UITextField!
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    @IBAction func hideRoutePopUp() {
        self.hidden = true
    }
    
}
