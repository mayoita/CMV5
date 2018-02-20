//
//  PopUp.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 18/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class PopUp: NSObject {
    
    let nero = UIView()
    let probabilitaV = Probabilita()
    
    func presentaPopUp (sender: AnyObject, icona: UIButton, vista: UIView, gioco: String, titolo: String) {
        if let window = UIApplication.shared.keyWindow {
            
            nero.backgroundColor = .black
            nero.alpha = 0
          
            nero.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(nero)
            nero.frame = window.frame
            
            probabilitaV.titolo.text = titolo
            probabilitaV.testo.text = gioco
            probabilitaV.contentView.frame = CGRect(x: 0, y: 0, width: 300, height: 350)
            probabilitaV.contentView.center = icona.center
            probabilitaV.alpha = 0
            probabilitaV.backgroundColor = .white
            
            probabilitaV.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            window.addSubview(probabilitaV)
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.probabilitaV.contentView.transform = CGAffineTransform.identity
                self.probabilitaV.contentView.center = vista.center
                self.probabilitaV.alpha = 1
                self.nero.alpha = 0.7
            }, completion: nil)
            
        }
    }
    func handleDismiss() {
        UIView.animate(withDuration: 0.3) {
            self.nero.alpha = 0
            self.probabilitaV.alpha = 0
        }
    }
    override init() {
        super.init()
    }

}
