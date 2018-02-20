//
//  Quando.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 02/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class Quando: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
 override func draw(_ rect: CGRect) {
 // Drawing code
 StyleKit.drawIconaQuando(frame: rect, color: StyleKit.oro)
 }

}
