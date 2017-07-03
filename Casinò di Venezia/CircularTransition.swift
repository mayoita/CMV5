//
//  CircularTransition.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 03/07/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class CircularTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var circle = UIView()
    
   let maskLayer = CAShapeLayer()
    var animation: CABasicAnimation!
    var topView: UIView!
    
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
    }
    
    var circleColor = UIColor.white
    var duration = 0.3
    enum CircularTransitionMode: Int {
        case present, dismiss, pop
    }
    
    var transitionMode: CircularTransitionMode = .present
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //From view controller
        let fromViewController = transitionContext.viewController(forKey:.from)
        let fromViewFrame = fromViewController?.view.frame
        
        //To view controller
        let toViewController = transitionContext.viewController(forKey: .to)
        //Container view
        let containerView = transitionContext.containerView
        
        if transitionMode == .present{
           
                
                topView = fromViewController?.view.resizableSnapshotView(from: fromViewFrame!, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0))
                
              //  let viewCenter = presentedView.center
              //  let viewSize = presentedView.frame.size
                maskLayer.frame = (toViewController?.view.frame)!
                // Create the frame for the circle.
                let radius: CGFloat = 50.0
                // Rectangle in which circle will be drawn
                let rect = CGRect(x: 100, y: 100, width: 2 * radius, height: 2 * radius)
                let circlePath = UIBezierPath(ovalIn: rect)
                // Create a path
                let path = UIBezierPath(rect: (toViewController?.view.bounds)!)
                // Append additional path which will create a circle
                path.append(circlePath)
                // Setup the fill rule to EvenOdd to properly mask the specified area and make a crater
                maskLayer.fillRule = kCAFillRuleEvenOdd
                // Append the circle to the path so that it is subtracted.
                maskLayer.path = path.cgPath
                // Mask our view with Blue background so that portion of red background is visible
                topView.layer.mask = maskLayer
                
//                circle = UIView()
//                circle.frame = frameCircle(withViewCenter: viewCenter, size: viewSize, starPoint: startingPoint)
//                circle.layer.cornerRadius = circle.frame.size.height / 2
//                circle.center = startingPoint
//                circle.backgroundColor = circleColor
//                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
//                containerView.addSubview(circle)
                
             //   presentedView.center = startingPoint
             //   presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
             //   presentedView.alpha = 0
                containerView.addSubview((toViewController?.view)!)
                containerView.addSubview(topView)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    self.topView.transform = CGAffineTransform.identity
                    self.topView.alpha = 1
                  //  topView.center = viewCenter
                }, completion: { (success:Bool) in
                    transitionContext.completeTransition(success)
                    
                })
            
        }
        }
    

    func frameCircle (withViewCenter viewCenter: CGPoint, size viewSize: CGSize, starPoint: CGPoint) -> CGRect {
        let xLength = fmax(starPoint.x, viewSize.width - starPoint.x)
        let yLenght = fmax(starPoint.y, viewSize.height - starPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLenght*yLenght)
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
    }
    
}
