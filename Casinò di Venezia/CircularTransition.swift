//
//  CircularTransition.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 03/07/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class CircularTransition: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    var circle = UIView()
    
   let maskLayer = CAShapeLayer()
    var animation: CABasicAnimation!
    var topView: UIView!
    var openingFrame: UIButton?
    var transitionContext: UIViewControllerContextTransitioning?
    var origin = CGPoint.zero
    
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    var circleColor = UIColor.white
    var duration = 0.5
    enum CircularTransitionMode: Int {
        case Present, Dismiss
    }
    
    var transitionMode: CircularTransitionMode = .Present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //From view controller
        let fromViewController = transitionContext.viewController(forKey:.from)
        
        
        //To view controller
        let toViewController = transitionContext.viewController(forKey: .to)
        let originalCenter = toViewController?.view.center
        let originalSize = toViewController?.view.frame.size
        //Container view
        let containerView = transitionContext.containerView
        self.transitionContext = transitionContext
        
        
        if transitionMode == .Present{
            // add our views to the container
            
           // containerView.addSubview((fromViewController?.view)!)
            containerView.addSubview((toViewController?.view)!)
            
            let maskPath = UIBezierPath(ovalIn: openingFrame!.frame)
            
            // define the masking layer to be able to show that circle animation
            let maskLayer = CAShapeLayer()
            maskLayer.frame = (toViewController?.view.frame)!
            maskLayer.path = maskPath.cgPath
            toViewController?.view.layer.mask = maskLayer
           
            // define the end frame
            var ret = frameCircle(withViewCenter: originalCenter!, size: originalSize!, starPoint: origin)
            ret.origin = CGPoint(x: ret.origin.x - (ret.midX - origin.x) , y: ret.origin.y - (ret.midY - origin.y))
            
            let bigCirclePath = UIBezierPath(ovalIn: ret)
            
            // create the animation
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.delegate = self
            pathAnimation.fromValue = maskPath.cgPath
            pathAnimation.toValue = bigCirclePath
            pathAnimation.duration = transitionDuration(using: transitionContext)
            maskLayer.path = bigCirclePath.cgPath
            maskLayer.add(pathAnimation, forKey: "pathAnimation")
        } else{
            
            containerView.addSubview((fromViewController?.view)!)
            //containerView.addSubview((toViewController?.view)!)
            //Define the start frame
            var ret = frameCircle(withViewCenter: originalCenter!, size: originalSize!, starPoint: origin)
            ret.origin = CGPoint(x: ret.origin.x - (ret.midX - origin.x) , y: ret.origin.y - (ret.midY - origin.y))
            let maskPath = UIBezierPath(ovalIn: ret)
            
            // define the masking layer to be able to show that circle animation
            let maskLayer = CAShapeLayer()
            maskLayer.frame = (toViewController?.view.frame)!
            maskLayer.path = maskPath.cgPath
            fromViewController?.view.layer.mask = maskLayer
            
            // define the end frame
            let bigCirclePath = UIBezierPath(ovalIn: openingFrame!.frame)
            
            // create the animation
            let pathAnimation = CABasicAnimation(keyPath: "path")
            pathAnimation.delegate = self
            pathAnimation.fromValue = maskPath.cgPath
            pathAnimation.toValue = bigCirclePath
            pathAnimation.duration = transitionDuration(using: transitionContext)
            maskLayer.path = bigCirclePath.cgPath
            maskLayer.add(pathAnimation, forKey: "pathAnimation")
            
        }
        }
    

    func frameCircle (withViewCenter viewCenter: CGPoint, size viewSize: CGSize, starPoint: CGPoint) -> CGRect {
        let xLength = fmax(starPoint.x, viewSize.width - starPoint.x)
        let yLenght = fmax(starPoint.y, viewSize.height - starPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLenght * yLenght) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let transitionContext = self.transitionContext {
            
            transitionContext.completeTransition(true)
        }
    }
    
}
