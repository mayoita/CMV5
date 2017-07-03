//
//  MapsViewController.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 30/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var isInitialized = false
    var event = Events()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        // Show the user current location
        mapView.showsUserLocation = true
        mapView.delegate = self
        
       
        
        
    }
    
  

    @IBAction func show(_ sender: Any) {
        var latitude: Double
        var longitude: Double
        if event.office == "VE" {
             latitude   = Constants.PALAZZO_LOREDAN_VENDRAMIN[0]
             longitude  = Constants.PALAZZO_LOREDAN_VENDRAMIN[1]
        } else {
             latitude   = Constants.CA_NOGHERA[0]
             longitude  = Constants.CA_NOGHERA[1]
        }
        let locationCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        var point = CasinoAnnotation(coordinate: locationCoordinates)
        point.title = "Ca Vendramin"
        
        // 3
        // Calculate Transit ETA Request
        let request = MKDirectionsRequest()
        /* Source MKMapItem */
        let sourceItem = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
        request.source = sourceItem
        /* Destination MKMapItem */
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: locationCoordinates, addressDictionary: nil))
        request.destination = destinationItem
        request.requestsAlternateRoutes = false
        // Looking for Transit directions, set the type to Transit
        request.transportType = .walking
        // Center the map region around the restaurant coordinates
        mapView.setCenter(locationCoordinates, animated: true)
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
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = true
        }else{
            annotationView?.annotation = annotation
        }
        
        let restaurantAnnotation = annotation as! CasinoAnnotation
        annotationView?.detailCalloutAccessoryView = UIImageView(image: restaurantAnnotation.image)
        
        // Left Accessory
        let leftAccessory = UILabel(frame: CGRect(x: 0,y: 0,width: 50,height: 30))
        leftAccessory.text = restaurantAnnotation.eta
        leftAccessory.font = UIFont(name: "Verdana", size: 10)
        annotationView?.leftCalloutAccessoryView = leftAccessory
        
        // Right accessory view
        let image = UIImage(named: "walk")
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(image, for: UIControlState())
        annotationView?.rightCalloutAccessoryView = button
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let placemark = MKPlacemark(coordinate: view.annotation!.coordinate, addressDictionary: nil)
        // The map item is the restaurant location
        let mapItem = MKMapItem(placemark: placemark)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    //MARK: MKMapViewDelegate
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        if !isInitialized {
//            isInitialized = true
//        let region = MKCoordinateRegion(center: self.mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        mapView.setRegion(region, animated: true)
//        }
//    }

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
            southwestLat   = Constants.PALAZZO_LOREDAN_VENDRAMIN[0]
            southwestLng  = Constants.PALAZZO_LOREDAN_VENDRAMIN[1]
        } else {
            southwestLat   = Constants.CA_NOGHERA[0]
            southwestLng  = Constants.CA_NOGHERA[1]
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
