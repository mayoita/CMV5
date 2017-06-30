//
//  ExpandAnimator.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 28/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//
import Foundation
import UIKit

class ExpandAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    static var animator = ExpandAnimator()
    
    enum ExpandTransitionMode: Int {
        case Present, Dismiss
    }
    
    let presentDuration = 0.4
    let dismissDuration = 0.15
    
    var openingFrame: CGRect?
    var transitionMode: ExpandTransitionMode = .Present
    
    var topView: UIView!
    var bottomView: UIView!
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if (transitionMode == .Present) {
            return presentDuration
        } else {
            return dismissDuration
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        //From view controller
        let fromViewController = transitionContext.viewController(forKey:.from)
        let fromViewFrame = fromViewController?.view.frame
        
        //To view controller
        let toViewController = transitionContext.viewController(forKey: .to)
        //Container view
        let containerView = transitionContext.containerView
        
        if (transitionMode == .Present) {
            //Get top view using resizableSnapshotViewFromRect
            topView = fromViewController?.view.resizableSnapshotView(from: fromViewFrame!, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake((openingFrame?.origin.y)!, 0, 0, 0))
            topView.frame = CGRect(x: 0, y: 0, width: (fromViewFrame?.width)!, height: (openingFrame?.origin.y)!)
            
            //Add top view to container
            containerView.addSubview(topView)
            
            //Get bottom view using resizableSnapshotViewFromRect
            bottomView = fromViewController?.view.resizableSnapshotView(from: fromViewFrame!, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(0, 0, (fromViewFrame?.height)! - (openingFrame?.origin.y)! - (openingFrame?.height)!, 0))
            bottomView.frame = CGRect(x: 0, y: (openingFrame?.origin.y)! + (openingFrame?.height)!, width: (fromViewFrame?.width)!, height: (fromViewFrame?.height)! - (openingFrame?.origin.y)! - (openingFrame?.height)!)
            
           
            
            //Take a snapshot of the view controller and change its frame to opening frame
            let snapshotView = toViewController?.view.resizableSnapshotView(from: fromViewFrame!, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0))
            
            //snapshotView?.frame = openingFrame!
            snapshotView?.frame = CGRect(x: 0, y: (openingFrame?.origin.y)!, width: (toViewController?.view.frame.width)!, height: (toViewController?.view.frame.height)!)
            containerView.addSubview(snapshotView!)
            
            //Add bottomview to container over snapshotview
            containerView.addSubview(bottomView)
            
            toViewController?.view.alpha = 0.0
            containerView.addSubview((toViewController?.view)!)
            UIView.animate(withDuration: presentDuration, animations: { () -> Void in
                //Move top and bottom views out of screen
                self.topView.frame = CGRect(x: 0, y: -self.topView.frame.height, width: self.topView.frame.width, height: self.topView.frame.height)
                self.bottomView.frame = CGRect(x: 0, y: fromViewFrame!.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
                //Expand snapshot view to fill entire frame
                snapshotView?.frame = (toViewController?.view.frame)!
                
            }, completion: {(finished) -> Void in
                
                //Remove snapshot view from container view
                snapshotView?.removeFromSuperview()
                self.bottomView.removeFromSuperview()
                
                //Make to view constroller visible
                toViewController?.view.alpha = 1.0
                
                //Complete transition
                transitionContext.completeTransition(finished)
                
            })
            
        } else {
            let snapshotView = fromViewController?.view.resizableSnapshotView(from: (fromViewController?.view.bounds)!, afterScreenUpdates: true, withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0))
            containerView.addSubview(snapshotView!)
            containerView.addSubview(bottomView)
            fromViewController?.view.alpha = 0.0
            
            UIView.animate(withDuration: dismissDuration, delay:0, options: UIViewAnimationOptions.curveEaseIn,  animations: { () -> Void in
                //Move top and bottom views out of screen
                self.topView.frame = CGRect(x: 0, y: 0, width: self.topView.frame.width, height: self.topView.frame.height)
                self.bottomView.frame = CGRect(x: 0, y: fromViewController!.view.frame.height - self.bottomView.frame.height, width: self.bottomView.frame.width, height: self.bottomView.frame.height)
                //Expand snapshot view to fill entire frame
                snapshotView?.frame = CGRect(x: 0, y: (self.openingFrame?.origin.y)!, width: (toViewController?.view.frame.width)!, height: (toViewController?.view.frame.height)!)
                
            }, completion: {(finished) -> Void in
                
                //Remove snapshot view from container view
                snapshotView?.removeFromSuperview()
                
                //Make to view constroller visible
                fromViewController?.view.alpha = 1.0
                
                //Complete transition
                transitionContext.completeTransition(finished)
                
            })
        }
        
        
    }
}
