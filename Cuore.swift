//
//  Cuore.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 10/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import Lottie

class Cuore: CALayer {
    var animationGroup = CAAnimationGroup()
    var animationDuration:TimeInterval = 1.5
    let timingFunction = CAMediaTimingFunction(controlPoints: 1/6, 1, 1, 1)
    var view:UIView?
    let fullRotation = CGFloat(Double.pi * 2)
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(position:CGPoint, view:UIView) {
        super.init()
        self.view = view
        self.position = position

        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            self.setupAnimationGroup()
            DispatchQueue.main.async {
                self.add(self.animationGroup, forKey: "cuore")
            }
        }
      
        
    }
    
    func positionAnimation () -> CABasicAnimation {
        let positionAnimation = CABasicAnimation(keyPath: "position.y")
        positionAnimation.fromValue = view?.center.y
        positionAnimation.toValue = (view?.center.y)! - 50
        positionAnimation.duration = animationDuration
        
        return positionAnimation
    }
    
    func opcacityAnimation() ->CAKeyframeAnimation {
        let opcacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opcacityAnimation.duration = animationDuration
        opcacityAnimation.values = [0.4, 0.8, 0]
        opcacityAnimation.keyTimes = [0, 0.2, 1]
        
        return opcacityAnimation
    }
    func rotationAnimation() ->CAKeyframeAnimation {
        let rot = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rot.duration = animationDuration
        rot.values = [0,1/12 * fullRotation,-1/12 * fullRotation,1/12 * fullRotation,0]
        rot.keyTimes = [0,0.25,0.5,0.75,1]
        return rot
    }
    
    func setupAnimationGroup() {
        self.animationGroup = CAAnimationGroup()
        self.animationGroup.duration = animationDuration
        self.animationGroup.timingFunction = timingFunction
        self.animationGroup.animations = [opcacityAnimation(), positionAnimation(),rotationAnimation()]
    }
}
