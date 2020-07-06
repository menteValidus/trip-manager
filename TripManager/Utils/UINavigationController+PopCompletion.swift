//
//  UINavigationController+PopCompletion.swift
//  Tripper
//
//  Created by Denis Cherniy on 10.04.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

extension UINavigationController {
    func popViewController(animated: Bool, completion: @escaping () -> ()) {
        popViewController(animated: animated)

        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion()
            }
        } else {
            completion()
        }
    }
}
