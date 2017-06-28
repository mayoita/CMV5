//
//  EventSegue.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 28/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class EventSegue: UIStoryboardSegue {
    override func perform() {
        scale()
    }
    
    func scale() {
        let toViewController = self.destination
        let fromViewController = self.source
        
        let containerView = fromViewController.view.superview
        let originalCenter = fromViewController.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 3.5, delay: 0, options: .curveEaseOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }, completion: { success in
            fromViewController.present(toViewController, animated: false, completion: nil)
            
        })
    }

}
