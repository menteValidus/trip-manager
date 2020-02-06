//
//  SlideInPresentationController.swift
//  Tripper
//
//  Created by Denis Cherniy on 06.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

enum ModalScaleState {
    case adjustedOnce
    case normal
}

class SlideInPresentationController: UIPresentationController {
    // MARK: - Properties
    private var presentationDirection: PresentationDirection
    private var dimmingView: UIView!
    
    private var panGestureRecognizer: UIPanGestureRecognizer
    private var direction: CGFloat = 0
    private var state: ModalScaleState = .normal
    private var isMaximized: Bool = false
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        
        switch presentationDirection {
        case .right:
            frame.origin.x = containerView!.frame.width * (1.0 / 3.0)
            
        case .bottom:
            frame.origin.y = containerView!.frame.height * (1.0 / 3.0)
            
        default:
            frame.origin = .zero
        }
        return frame
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, direction: PresentationDirection) {
        self.presentationDirection = direction
        self.panGestureRecognizer = UIPanGestureRecognizer()
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        panGestureRecognizer.addTarget(self, action: #selector(onPan(pan:)))
        setupDimmingView()
    }
    
    
    // MARK: - Transition Methods
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else {
            return
        }
        containerView?.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|", options: [], metrics: nil, views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    // MARK: - Layout Methods
    
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        switch presentationDirection {
        case .left, .right:
            return CGSize(width: parentSize.width * (2.0 / 3.0), height: parentSize.height)
        default:
            return CGSize(width: parentSize.width, height: parentSize.height * (2.0 / 3.0))
        }
    }
}

// MARK: - Private
private extension SlideInPresentationController {
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
        let recognizer = UITapGestureRecognizer(
          target: self,
          action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    // MARK: - Gesture Handlers
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
      presentingViewController.dismiss(animated: true)
    }

    @objc func onPan(pan: UIPanGestureRecognizer) {
        let endPoint = pan.translation(in: pan.view?.superview)
        
        switch pan.state {
            
        case .began:
            presentedView!.frame.size.height = containerView!.frame.height
            
        case .changed:
            let velocity = pan.velocity(in: pan.view?.superview)
            print(velocity.y)
            
            presentedView!.frame.origin.y = endPoint.y + containerView!.frame.height / 2
            direction = velocity.y
            
        case .ended:
            if direction < 0 {
                changeScale(to: .adjustedOnce)
            } else {
                if state == .adjustedOnce {
                    changeScale(to: .normal)
                } else {
                    presentedViewController.dismiss(animated: true, completion: nil)
                }
            }
            
        default:
            break
        }
        
    }
    
    // MARK: - Helper Methods
    
    func changeScale(to state: ModalScaleState) {
        if let presentedView = presentedView, let containerView = self.containerView {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
                presentedView.frame = containerView.frame
                let containerFrame = containerView.frame
                let halfFrame = CGRect(origin: CGPoint(x: 0, y: containerFrame.height / 2),
                                       size: CGSize(width: containerFrame.width, height: containerFrame.height / 2))
                let frame = state == .adjustedOnce ? containerView.frame : halfFrame
                
                presentedView.frame = frame
                
                if let navController = self.presentedViewController as? UINavigationController {
                    self.isMaximized = true
                    
                    navController.setNeedsStatusBarAppearanceUpdate()
                    
                    // Force the navigation bar to update its size
                    navController.isNavigationBarHidden = true
                    navController.isNavigationBarHidden = false
                }
            }, completion: { _ in
                self.state = state
            })
        }
    }
    
}
