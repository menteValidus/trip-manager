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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = routePoint.title ?? "Title"
    }

}
