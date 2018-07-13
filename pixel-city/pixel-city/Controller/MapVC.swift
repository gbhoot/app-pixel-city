//
//  MapVC.swift
//  pixel-city
//
//  Created by Gurpreet Bhoot on 7/12/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    // Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UIView!
    @IBOutlet weak var currentLocationBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func currentLocationBtnPressed(_ sender: Any) {
        
    }
}

// Does the same thing as inheriting the MKMapViewDelegate at the top in Class instance
extension MapVC: MKMapViewDelegate {
    
}

