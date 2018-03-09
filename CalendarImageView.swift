//
//  CalendarImageView.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 06/03/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class CalendarImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var evento: Events?
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
        
    }
    convenience init(frame: CGRect, evento: Events) {
        self.init(frame: frame)
        self.evento = evento
    }
}
