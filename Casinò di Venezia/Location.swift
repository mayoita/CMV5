//
//  Location.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 07/07/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import CoreLocation

class Location: NSObject {
    var name: String
    var image: UIImage
    var address: NSDictionary = [:]
    var tel:String
    var location: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    
    init(name: String, image: UIImage, tel: String) {
        self.name = name
        self.image = image
        self.tel = tel
    }

}
