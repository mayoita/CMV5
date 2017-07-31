//
//  CasinoAnnotationView.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 04/07/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import MapKit

private let kPersonMapPinImage = UIImage(named: "mapPin")!
private let kPersonMapAnimationTime = 0.300

//https://digitalleaves.com/blog/2016/12/building-the-perfect-ios-map-ii-completely-custom-annotation-views/

class CasinoAnnotationView: MKAnnotationView {

    // data
    weak var customCalloutView: PersonDetailMapView?
     weak var personDetailDelegate: PersonDetailMapViewDelegate?
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    

    // MARK: - life cycle
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false // 1
        self.image = kPersonMapPinImage
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // 1
        self.image = kPersonMapPinImage
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadPersonDetailMapView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView
                
                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
//        } else {
//            if customCalloutView != nil {
//                if animated { // fade out animation, then remove it.
//                    UIView.animate(withDuration: kPersonMapAnimationTime, animations: {
//                        self.customCalloutView!.alpha = 0.0
//                    }, completion: { (success) in
//                        self.customCalloutView!.removeFromSuperview()
//                    })
//                } else { self.customCalloutView!.removeFromSuperview() } // just remove it.
//            }
//        }
    }
    
    func loadPersonDetailMapView() -> PersonDetailMapView? {
        if let views = Bundle.main.loadNibNamed("PersonDetailMapView", owner: self, options: nil) as? [PersonDetailMapView], views.count > 0 {
            let personDetailMapView = views.first!
            personDetailMapView.delegate = self.personDetailDelegate
            if let personAnnotation = annotation as? CasinoAnnotation {
                let person = personAnnotation.location
                personDetailMapView.configureWithPerson(person: person)
            }
            return personDetailMapView
        }
        return nil
    }
    
    // MARK: - Detecting and reaction to taps on custom callout.
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) { return parentHitView }
        else { // test in our custom callout.
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else { return nil }
        }
    }
    
    
    override func prepareForReuse() { // 5
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
}
