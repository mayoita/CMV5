//
//  EventListCell.swift
//  CMVG
//
//  Created by Massimo Moro on 22/06/17.
//  Copyright © 2017 Massimo Moro. All rights reserved.
//

import UIKit
import AVFoundation
import Canvas
import Spring

class EventListCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView! 
  

    @IBOutlet weak var micro: SpringButton! {
        didSet {
            micro.setImage(StyleKit.imageOfSpeaking(imageSize: CGSize(width: 45, height: 45), color: StyleKit.nero), for: .normal)
        }
    }
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var DoveLabel: UILabel!
    @IBOutlet weak var titoloHeight: NSLayoutConstraint!
    @IBOutlet weak var QuandoLabel: UILabel!

    
    var speakingText: String = "Nothing to read";
    let synthesizer = AVSpeechSynthesizer()
    var isSpeaking:Bool = false
    @IBAction func micro_speaking(_ sender: Any) {
        isSpeaking = !isSpeaking
        //micro.layer.removeAllAnimations()
        let utterance = AVSpeechUtterance(string: speakingText)
        if isSpeaking {
            synthesizer.speak(utterance)
            micro.setImage(StyleKit.imageOfSpeak_acceso(), for: .normal)
            micro.animation = "flash"
            micro.duration = 1.0
            micro.repeatCount = 30
            micro.animate()
            
        }else {
            synthesizer.stopSpeaking(at: .immediate)
            micro.setImage(StyleKit.imageOfSpeaking(imageSize: CGSize(width: 45, height: 45), color: StyleKit.nero), for: .normal)
           micro.layer.removeAllAnimations()
        }
    }
    

  
    @IBOutlet weak var intro: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       titolo.font = UIFont(name: "VeniceCasino-Regular", size: 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       backgroundColor = .white
        
        
    }
    
    
 
}
