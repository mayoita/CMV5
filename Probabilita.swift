//
//  Probabilita.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 17/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class Probabilita: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titolo: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        commonInit()
    }
    func commonInit() {
        Bundle.main.loadNibNamed("Probabilita", owner: self, options: nil)
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
