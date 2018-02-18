//
//  GiochiCella.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 14/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class GiochiCella: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var intro: UITextView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
        
    }
    
}
