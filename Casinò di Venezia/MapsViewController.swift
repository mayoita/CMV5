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
    var event = Events()
    var sedi = [Location]()

    @IBOutlet var detailView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        // Show the user current location
        mapView.showsUserLocation = true
        mapView.delegate = self
        popolaSedi()
    }
    
    func popolaSedi () {
        sedi = []
        for index in 0...1 {
            let location = Location(name: Constants.sedi[index], image: Constants.immaginiSedi[index]!, tel: Constants.telefono[index])
            location.location = Constants.coordinates[index]
            location.address = Constants.address[index] as NSDictionary
          
            sedi.append(location)
        }
        
    }
    
    @IBAction func show(_ sender: Any) {
       
    }
    
    func calculateETA(){

        var point = CasinoAnnotation(location: sedi[0])
        if event.office == "CN" {
            point = CasinoAnnotation(location: sedi[1])
        }
        
        // 3
        // Calculate Transit ETA Request
        let request = MKDirectionsRequest()
        /* Source MKMapItem */
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
        request.source = sourceItem
        /* Destination MKMapItem */
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: point.coordinate, addressDictionary: nil))
        request.destination = destinationItem
        request.requestsAlternateRoutes = false
        // Looking for Transit directions, set the type to Transit
        request.transportType = .walking
        // Center the map region around the restaurant coordinates
        mapView.setCenter(point.coordinate, animated: true)
        // You use the MKDirectionsRequest object constructed above to initialise an MKDirections object
        let directions = MKDirections(request: request)
        directions.calculateETA { (etaResponse, error) -> Void in
            if let error = error {
                print("Error while requesting ETA : \(error.localizedDescription)")
                point.eta = error.localizedDescription
            }else{
                point.eta = "\(Int((etaResponse?.expectedTravelTime)!/60)) min"
            }
            // 4
            var isExist = false
            for annotation in self.mapView.annotations{
                if annotation.coordinate.longitude == point.coordinate.longitude && annotation.coordinate.latitude == point.coordinate.latitude{
                    isExist = true
                    point = annotation as! CasinoAnnotation
                }
            }
            if !isExist{
                self.mapView.addAnnotation(point)
            }
            self.mapView.selectAnnotation(point, animated: true)
            
        }
        
        setZoomRect()
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
        self.calculateETA()
        }
    }

    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    func setZoomRect() {
        let newLocation: CLLocation? = locationManager.location
        var annotationCenter: CLLocationCoordinate2D = CLLocationCoordinate2D()
        var southwestLat: CLLocationDegrees
        var southwestLng: CLLocationDegrees
        var northeastLat: CLLocationDegrees
        var northeastLng: CLLocationDegrees
        northeastLat = (newLocation?.coordinate.latitude)!
        northeastLng = (newLocation?.coordinate.longitude)!
        if event.office == "VE" {
            southwestLat   = Constants.coordinates[0].latitude
            southwestLng  = Constants.coordinates[0].longitude
        } else {
            southwestLat   = Constants.coordinates[1].latitude
            southwestLng  = Constants.coordinates[1].longitude
        }
        var span: MKCoordinateSpan = MKCoordinateSpan()
        span.longitudeDelta = fabs(Double(northeastLng - southwestLng))
        span.latitudeDelta = fabs(Double(northeastLat - southwestLat))
        annotationCenter.longitude = (northeastLng + southwestLng) / 2
        annotationCenter.latitude = (northeastLat + southwestLat) / 2
        span.longitudeDelta = span.longitudeDelta * 1.6
        span.latitudeDelta = span.latitudeDelta * 1.6
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
