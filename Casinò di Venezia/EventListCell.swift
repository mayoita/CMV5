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

class EventListCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView! 
  
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var DoveLabel: UILabel!
    @IBOutlet weak var titoloHeight: NSLayoutConstraint!
    @IBOutlet weak var QuandoLabel: UILabel!
    @IBOutlet weak var speaking: UIButton! {
        didSet {
            let animation = CSAnimationView()
            speaking.addSubview(animation)
            //speaking.customView = CSAnimationView()
        }
    }
    
    
    var speakingText: String = "Nothing to read";
    let synthesizer = AVSpeechSynthesizer()
    var isSpeaking:Bool = false
    
    @IBAction func speaking(_ sender: Any) {
        isSpeaking = !isSpeaking
        let utterance = AVSpeechUtterance(string: speakingText)
        if isSpeaking {
            synthesizer.speak(utterance)
        }else {
           synthesizer.stopSpeaking(at: .immediate)
        }
    }
  
    @IBOutlet weak var intro: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       backgroundColor = .white
    
    }
    
    
 
}
