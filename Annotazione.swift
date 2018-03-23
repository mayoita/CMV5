//
//  Annotazione.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 21/03/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
protocol AnnotazioneDelegate: class {
    func detailsRequestedForPerson(person: Location)
}

class Annotazione: UIView {

    // outlets
    @IBOutlet weak var backgroundContentButton: UIButton!

    @IBOutlet weak var seeDetailsButton: UIButton!
    
    // data
    var person: Location!
    weak var delegate: AnnotazioneDelegate?
    
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
