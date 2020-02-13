//
//  AnnotationDetailViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 06.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class AnnotationDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    
    var routePoint: RoutePoint!
    var delegate: MapRouteDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = routePoint.title ?? "Title"
        titleTextField.text = routePoint.title
    }

    // MARK: - Actions
    
    @IBAction func save(_ sender: UIButton) {
        routePoint.title = titleTextField.text
        delegate.mapRoute(didChanged: routePoint)
        dismiss(animated: true)
    }
    
    @IBAction func deletePoint(_ sender: Any) {
        delegate.mapRoute(didDeleted: routePoint)
        dismiss(animated: true)
    }
}
