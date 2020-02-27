//
//  ModalInteractiveTransition.swift
//  Tripper
//
//  Created by Denis Cherniy on 27.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class ModalInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var viewController: UIViewController
    var presentingViewController: UIViewController?
    var panGestureRecognizer: UIPanGestureRecognizer
    
    var shouldComplete: Bool = false
    
    init(viewController: UIViewController, withView view: UIView, presentingViewController: UIViewController?) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController
        self.panGestureRecognizer = UIPanGestureRecognizer()
        
        super.init()
        
        self.panGestureRecognizer.addTarget(self, action: #selector(onPan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: - Actions
    
    @objc func onPan(pan: UIPanGestureRecognizer) -> Void {
        
    }
}
