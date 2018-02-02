//
//  Constants.swift
//  CMVG
//
//  Created by Massimo Moro on 22/06/17.
//  Copyright © 2017 Massimo Moro. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import Contacts

struct Constants {
    static let sediciNoni = CGFloat(0.66)
 
//    static let coordinates = [
//    CLLocationCoordinate2D(latitude: 45.442494, longitude: 12.329699),
//    CLLocationCoordinate2D(latitude: 45.520453, longitude: 12.358219)
//    ]
    static let coordinates = [
        CLLocationCoordinate2D(latitude: 45.44284, longitude: 12.32988),
        CLLocationCoordinate2D(latitude: 45.520532, longitude: 12.358032)
    ]
    static let sedi = [
        "Ca'Vendramin Calergi",
        "Ca'Noghera"
    ]
    static let telefono = [
        "tel. +39(0)41-5297111",
        "tel. +39(0)41-2695888"
    ]
    static let immaginiSedi = [
        UIImage(named: "mapAnnotationCV"),
        UIImage(named: "mapAnnotationCN")
    ]
    static let address = [
        [CNPostalAddressStreetKey: "Cannaregio, 2040",
         CNPostalAddressCityKey: "Venezia",
         CNPostalAddressPostalCodeKey: "30121",
         CNPostalAddressISOCountryCodeKey: "IT"],
        [CNPostalAddressStreetKey: "Via Paliaga 4/8",
                          CNPostalAddressCityKey: "Venezia",
                          CNPostalAddressPostalCodeKey: "30173",
                          CNPostalAddressISOCountryCodeKey: "IT"]
    
    ]
    
}
