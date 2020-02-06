//
//  SlideInPresentationManager.swift
//  Tripper
//
//  Created by Denis Cherniy on 06.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

enum PresentationDirection {
    case left
    case top
    case right
    case bottom
}

class SlideInPresentationManager: NSObject {
    var direction: PresentationDirection = .left
    
}

// MARK: - UIViewControllerTransitionDelegate

extension SlideInPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController =
            SlideInPresentationController(presentedViewController: presented, presenting: presenting, direction: direction)
        return presentationController
    }
}
