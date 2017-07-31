//
//  CasinoAnnotation.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 30/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import MapKit

class CasinoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D { return location.location }
    var location: Location
    var eta: String?
    
  
    init(location: Location) {
        self.location = location
        super.init()
    }
    
    var name: String? {
        return location.name
    }
}
