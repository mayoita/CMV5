//
//  MapsViewController.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 30/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import MapKit
import Contacts
private let kPersonWishListAnnotationName = "kPersonWishListAnnotationName"

class MapsViewController: UIViewController, MKMapViewDelegate, PersonDetailMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
   
    var locationManager: CLLocationManager!
    var isInitialized = false

    var sedi = [Location]()

    var sediNome:[String]?
    var locations:[Int] = []
    enum nomeSedi: Int {
        case VE = 0
        case CN = 1
    }

    @IBOutlet var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for sede in sediNome! {
            switch sede {
            case "VE":
                locations.append(0)
            case "CN":
                locations.append(1)
            default:
                return
            
            }
        }
        locationManager = CLLocationManager()
        //locations = [nomeSedi.CN.rawValue, nomeSedi.VE.rawValue]
        mapView.delegate = self
        popolaSedi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func popolaSedi () {
        sedi = []
        for index in locations {
            let location = Location(name: Constants.sedi[index], image: Constants.immaginiSedi[index]!, tel: Constants.telefono[index])
            location.location = Constants.coordinates[index]
            location.address = Constants.address[index] as NSDictionary
          
            sedi.append(location)
        }
        
    }
    

    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is CasinoAnnotation){
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: kPersonWishListAnnotationName)
        
        if annotationView == nil {
            annotationView = CasinoAnnotationView(annotation: annotation, reuseIdentifier: kPersonWishListAnnotationName)
            (annotationView as! CasinoAnnotationView).personDetailDelegate = self
            
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
        // The map item is the restaurant location
        let mapItem = MKMapItem(placemark: placemark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    func detailsRequestedForPerson(person: Location) {

        let placemark = MKPlacemark(coordinate: person.location, addressDictionary: (person.address as! [String : Any]) )
        // The map item is the restaurant location
        let mapItem = MKMapItem(placemark: placemark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !isInitialized {
            isInitialized = true
            for (index, item) in locations.enumerated() {
                let point = CasinoAnnotation(location: sedi[index])
                self.mapView.addAnnotation(point)
                self.mapView.selectAnnotation(point, animated: true)
            }

            setZoomRect()
        }
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func setZoomRect() {
        let newLocation: CLLocation? = locationManager.location
        var annotationCenter: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var southwestLat: CLLocationDegrees = 0
        var southwestLng: CLLocationDegrees = 0
        var northeastLat: CLLocationDegrees
        var northeastLng: CLLocationDegrees
        northeastLat = (newLocation?.coordinate.latitude)!
        northeastLng = (newLocation?.coordinate.longitude)!
        for index in locations {
            southwestLat   = southwestLat + Constants.coordinates[index].latitude
            southwestLng = southwestLng + Constants.coordinates[index].longitude
        }
        southwestLat = southwestLat / CLLocationDegrees(locations.count)
        southwestLng = southwestLng / CLLocationDegrees(locations.count)

        var span: MKCoordinateSpan = MKCoordinateSpan()
        span.longitudeDelta = fabs(Double(northeastLng - southwestLng))
        span.latitudeDelta = fabs(Double(northeastLat - southwestLat))
        annotationCenter.longitude = (northeastLng + southwestLng) / 2
        annotationCenter.latitude = (northeastLat + southwestLat) / 2
        span.longitudeDelta = span.longitudeDelta * 3.6
        span.latitudeDelta = span.latitudeDelta * 3.6
        var region: MKCoordinateRegion = MKCoordinateRegion()
        region.center = annotationCenter
        region.span = span
        mapView.setRegion(region, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
