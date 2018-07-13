//
//  DroppablePin.swift
//  pixel-city
//
//  Created by Gurpreet Bhoot on 7/12/18.
//  Copyright © 2018 Gurpal Bhoot. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {

    // Variables
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String

    // Custom init function
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
