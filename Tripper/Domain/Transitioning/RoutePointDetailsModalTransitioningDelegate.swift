//
//  RoutePointDetailModalTransitioningDelegate.swift
//  Tripper
//
//  Created by Denis Cherniy on 03.03.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import Foundation
import UIKit

final class RoutePointDetailsModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var interactiveDismiss = true
    
    init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
    }
    
    // MARK: - UIViewControllerTransitionigDelegate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return RoutePointDetailsModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}
