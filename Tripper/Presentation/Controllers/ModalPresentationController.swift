//
//  ModalPresentationController.swift
//  Tripper
//
//  Created by Denis Cherniy on 27.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

enum ModalScaleState {
    case adjustedOnce
    case normal
}

class ModalPresentationController: UIPresentationController {
    var isMaximized: Bool = false
    
    var _dimmingView: UIView?
    var panGestureRecognizer: UIPanGestureRecognizer
    var direction: CGFloat = 0
    var state: ModalScaleState = .normal
     
    var dimmingView: UIView {
           if let dimmedView = _dimmingView {
               return dimmedView
           }
           
           let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))
           
           // Blur Effect
           let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
           let blurEffectView = UIVisualEffectView(effect: blurEffect)
           blurEffectView.frame = view.bounds
           view.addSubview(blurEffectView)
           
           // Vibrancy Effect
           let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
           let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
           vibrancyEffectView.frame = view.bounds
           
           // Add the vibrancy view to the blur view
           blurEffectView.contentView.addSubview(vibrancyEffectView)
           
           _dimmingView = view
           
           return view
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: containerView!.bounds.height / 2, width: containerView!.bounds.width, height: containerView!.bounds.height / 2)
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        self.panGestureRecognizer = UIPanGestureRecognizer()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        panGestureRecognizer.addTarget(self, action: #selector(onPan(pan:)))
        presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func onPan(pan: UIPanGestureRecognizer) {
        let endPoint = pan.translation(in: pan.view?.superview)
        
        switch pan.state {
        case .began:
            presentedView!.frame.size.height = containerView!.frame.height / 2
        case .changed:
            let velocity = pan.velocity(in: pan.view?.superview)
            print("*** ModalPresentationController.onPan: velocity \(velocity.y)")
            switch state {
            case .normal:
                presentedView!.frame.origin.y = endPoint.y + containerView!.frame.height / 2
            case .adjustedOnce:
                presentedView!.frame.origin.y = endPoint.y
            }
            direction = velocity.y
        case .ended:
            if direction < 0 {
                changeScale(to: .adjustedOnce)
            } else {
                if state == .adjustedOnce {
                    changeScale(to: .normal)
                } else {
                    presentingViewController.dismiss(animated: true, completion: nil)
                }
            }
            print("*** ModalPresentationController.onPan: Finished transition.")
        default:
            break
        }
    }
    
    func changeScale(to state: ModalScaleState) {
        if let presentedView = presentedView, let containerView = self.containerView {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                presentedView.frame = containerView.frame
                let containerFrame = containerView.frame
                let halfFrame = CGRect(origin: CGPoint(x: 0, y: containerFrame.height / 2),
                                       size: CGSize(width: containerFrame.width, height: containerFrame.height / 2))
                let frame = state == .adjustedOnce ? containerView.frame : halfFrame
                
                presentedView.frame = frame
            }, completion: { (isFinished) in
                self.state = state
            })
        }
    }
    
    override func presentationTransitionWillBegin() {
        let dimmedView = dimmingView
        
        if let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator {
            dimmingView.alpha = 0
            containerView.addSubview(dimmedView)
            dimmedView.addSubview(presentedViewController.view)
            
            coordinator.animate(alongsideTransition: { context in
                dimmedView.alpha = 1
                self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { context in
                self.dimmingView.alpha = 0
                self.presentedViewController.view.transform = CGAffineTransform.identity
            }, completion: { completed in
                print("*** Done dismiss animation")
            })
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        print("*** Dismissal did end: \(completed)")
        
        if completed {
            dimmingView.removeFromSuperview()
            _dimmingView = nil
            
            isMaximized = false
        }
    }
    
}

protocol ModalPresentable { }

extension ModalPresentable where Self: UIViewController {
    func maximizeToFullScreen() {
        if let presentation = navigationController?.presentationController as? ModalPresentationController {
            presentation.changeScale(to: .adjustedOnce)
        }
    }
}

extension ModalPresentable where Self: UINavigationController {
    func isHalfModalMaximized() -> Bool {
        if let presentationController = presentationController as? ModalPresentationController {
            return presentationController.isMaximized
        }
        
        return false
    }
}
