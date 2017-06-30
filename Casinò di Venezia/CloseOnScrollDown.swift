//
//  CloseOnScrollDown.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 30/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit

class CloseOnScrollDown: UIPercentDrivenInteractiveTransition {
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    var hasStarted = false
    var shouldFinish = false
    
    func wireToViewController(viewController: UIViewController!) {
        self.viewController = viewController
        prepareGestureRecognizerInView(view: viewController.view)
    }
    
    private func prepareGestureRecognizerInView(view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(sender:)))
        //gesture.edges = UIRectEdge.top
        view.addGestureRecognizer(gesture)
    }
    func handleGesture(sender: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in:sender.view!.superview!)
        let verticalMovement = translation.y / sender.view!.superview!.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        
        
        switch sender.state {
        case .began:
            hasStarted = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldFinish = progress > percentThreshold
            update(progress)
        case .cancelled:
            hasStarted = false
            cancel()
        case .ended:
           hasStarted = false
            shouldFinish
                ? finish()
                : cancel()
        default:
            break
        }
//        // 1
//        let translation = sender.translation(in:sender.view!.superview!)
//        var progress = (translation.x / 200)
//        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
//        
//        switch sender.state {
//            
//        case .began:
//            // 2
//            interactionInProgress = true
//            viewController.dismiss(animated: true, completion: nil)
//            
//        case .changed:
//            // 3
//            shouldCompleteTransition = progress > 0.5
//            update(progress)
//            
//        case .cancelled:
//            // 4
//            interactionInProgress = false
//            cancel()
//            
//        case .ended:
//            // 5
//            interactionInProgress = false
//            
//            if !shouldCompleteTransition {
//                cancel()
//            } else {
//                finish()
//            }
//            
//        default:
//            print("Unsupported")
//        }
    }
}
