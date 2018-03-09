//
//  CalendarCell.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 27/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import JTAppleCalendar


class CalendarCell: JTAppleCell {

    @IBOutlet weak var giorno: UILabel!
    @IBOutlet weak var contenitoreEventi: UIView!

    var eventi:[Events] = []
    var eventoOriginale:Events?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
     
    }

}
