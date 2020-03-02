//
//  ModalTransitionAnimator.swift
//  Tripper
//
//  Created by Denis Cherniy on 27.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

internal enum ModalTransitionAnimatorType {
    case present
    case dismiss
}

class ModalTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var type: ModalTransitionAnimatorType
    
    init(type: ModalTransitionAnimatorType) {
        self.type = type
        display(message: "ModalTransitionAnimator inited")
    }
    
    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        display(message: "ModalTransitionAnimator.animateTransition")
        let _ = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let from = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            
            from!.view.frame.origin.y = 800
            
            print("animating...")
            
        }) { (completed) -> Void in
            print("animate completed")
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        display(message: "ModalTransitionAnimator.transitionDuration")
        return 0.4
    }
}

