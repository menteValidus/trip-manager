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
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
