//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import FoldingCell
import UIKit
import MapKit
private let kPersonWishListAnnotationName = "kPersonWishListAnnotationName"
class DemoCell: FoldingCell,MKMapViewDelegate,AnnotazioneDelegate {

  
    var locationManager: CLLocationManager!
    var isInitialized = false
    
    var sedi = [Location]()
    var telefono: String?
    var sediNome:[String]? {
        didSet{
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
            popolaSedi()
        }
    }
    var locations:[Int] = []
    enum nomeSedi: Int {
        case VE = 0
        case CN = 1
    }
    @IBOutlet weak var oggi: UILabel!
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var storia: UILabel!
    @IBOutlet weak var orari: UILabel!
    @IBOutlet weak var dalleAlle: UILabel!
    @IBOutlet weak var apertoIl: UILabel!
    @IBOutlet weak var immagine: UIImageView!
    @IBOutlet weak var storiaTEsto: UITextView!{
        didSet{
            storiaTEsto.scrollRangeToVisible(NSMakeRange(0, 0))
        }
    }
    @IBOutlet weak var sabato: UILabel!
    @IBOutlet weak var orari2: UILabel!
    @IBOutlet weak var oggiAperto: UILabel!
    @IBOutlet weak var titoloSede: UILabel!
    @IBOutlet weak var chiama: UIButton!
    

    @IBOutlet weak var mapView: MKMapView!
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
         checkLocationAuthorizationStatus()
        locationManager = CLLocationManager()
       
        mapView.delegate = self
        storia.text = "STORIA".localized
        oggi.text = "OGGI".localized
        orari.text = "ORARI".localized
       
        chiama.setImage(StyleKit.imageOfTel(), for: .normal)
        chiama.imageView?.contentMode = .scaleAspectFit
        chiama.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
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
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // If annotation is not of type RestaurantAnnotation (MKUserLocation types for instance), return nil
        if !(annotation is CasinoAnnotation){
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: kPersonWishListAnnotationName)
        
        if annotationView == nil {
            annotationView = AnnotazioneHome(annotation: annotation, reuseIdentifier: kPersonWishListAnnotationName)
            (annotationView as! AnnotazioneHome).personDetailDelegate = self
            
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
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}

// MARK: - Actions ⚡️

extension DemoCell {

    @IBAction func buttonHandler(_: AnyObject) {
        let URLTel = "tel://" + telefono!
        if let url = URL(string:URLTel), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
}
