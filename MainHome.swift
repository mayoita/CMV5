//
//  MainHome.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 20/03/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import Firebase
import MarqueeLabel
class MainHome: UICollectionViewCell {

let storyboard = UIStoryboard(name: "Main", bundle: nil)
    @IBAction func apriVE(_ sender: Any) {
        let mapVC = storyboard.instantiateViewController(withIdentifier: "MapView") as! MapsViewController
        mapVC.sediNome = ["VE"]
        
        //mapVC.transitioningDelegate = self
        //mapVC.modalPresentationStyle = .custom
        if let keyWindow = UIApplication.shared.keyWindow?.rootViewController {
            keyWindow.present(mapVC, animated: true, completion: nil)
        }
        
    }
    
    @IBOutlet weak var feedNews: MarqueeLabel!
    var databaseRef:DatabaseReference  = Database.database().reference()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        let feed = databaseRef.child("News")
        feed.observe(DataEventType.value, with: { (snapshot) in
           let value = snapshot.value as? NSDictionary
            let text = value?["feed"] as? String ?? ""
            if text != "" {
                self.feedNews.text = "** NEWS ** " + text
            } else {
                self.feedNews.text = ""
            }
            
        })
        feedNews.tag = 201
        feedNews.type = .continuous
        feedNews.textAlignment = .right
        feedNews.lineBreakMode = .byTruncatingHead
        feedNews.speed = .rate(60)
        feedNews.fadeLength = 15.0
        feedNews.leadingBuffer = 30.0
        
        feedNews.trailingBuffer = 20
        feedNews.animationCurve = .easeInOut
        
        feedNews.isUserInteractionEnabled = true // Don't forget this, otherwise the gesture recognizer will fail (UILabel has this as NO by default)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pauseTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        feedNews.addGestureRecognizer(tapRecognizer)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    @objc func pauseTap(_ recognizer: UIGestureRecognizer) {
        let continuousLabel2 = recognizer.view as! MarqueeLabel
        if recognizer.state == .ended {
            continuousLabel2.isPaused ? continuousLabel2.unpauseLabel() : continuousLabel2.pauseLabel()
        }
    }
    @IBAction func callVE(_ sender: Any) {
        if let url = URL(string:"tel://0415297111"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
    
    
}
