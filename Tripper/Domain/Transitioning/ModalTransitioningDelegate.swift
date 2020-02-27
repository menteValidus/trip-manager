//
//  ModalTransitioningDelegate.swift
//  Tripper
//
//  Created by Denis Cherniy on 27.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class ModalTransitionigDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var viewController: UIViewController
    var presentingViewController: UIViewController
    var interactionController: ModalInteractiveTransition
    
    var interactiveDismiss = true
    
    init(viewController: UIViewController, presentingViewController: UIViewController) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController
        self.interactionController = ModalInteractiveTransition(viewController: self.viewController, withView: self.presentingViewController.view, presentingViewController: self.presentingViewController)
        
        super.init()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return
    }
}
