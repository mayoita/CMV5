//
//  CanvasButton.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 03/07/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import Canvas

class CanvasButton: CSAnimationView {
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    required public init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
        let button: UIButton = UIButton(frame:CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width, height: self.bounds.size.height))
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.setImage(UIImage(named: "micro"), for: .normal)
        
        self.addSubview(button)
    }
    



    
    func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
}
