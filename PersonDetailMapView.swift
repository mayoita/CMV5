//
//  PersonDetailMapView.swift
//  CustomPinsMap
//
//  Created by Ignacio Nieto Carvajal on 6/12/16.
//  Copyright © 2016 Ignacio Nieto Carvajal. All rights reserved.
//

import UIKit

protocol PersonDetailMapViewDelegate: class {
    func detailsRequestedForPerson(person: Location)
}

class PersonDetailMapView: UIView {
    // outlets
    @IBOutlet weak var backgroundContentButton: UIButton!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personName: UILabel!

    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var seeDetailsButton: UIButton!
    
    // data
    var person: Location!
    weak var delegate: PersonDetailMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    
        // appearance
         backgroundContentButton.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down)
        seeDetailsButton.setTitle("Ottieni indicazioni".localized, for: .normal)
       
    }
    
    @IBAction func seeDetails(_ sender: Any) {
        delegate?.detailsRequestedForPerson(person: person)
    }
    
    func configureWithPerson(person: Location) {
        self.person = person
        
        personImageView.image = person.image
        personName.text = person.name
        tel.text = person.tel
    }

    
    // MARK: - Hit test. We need to override this to detect hits in our custom callout.
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Check if it hit our annotation detail view components.

        // details button
        if let result = seeDetailsButton.hitTest(convert(point, to: seeDetailsButton), with: event) {
            return result
        }
    
        // fallback to our background content view
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
 
}
