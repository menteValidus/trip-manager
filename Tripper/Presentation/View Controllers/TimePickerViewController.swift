//
//  TimePickerViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 13.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class TimePickerViewController: UIViewController {
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: AnnotationDetailDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Actions
    
    @IBAction func accept(_ sender: Any) {
        delegate.annotationDetail(didSet: datePicker.date)
        dismiss(animated: true, completion: {
            print("*** TimePicker dismissed")
        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: {
            print("*** TimePicker dismissed")
        })
    }
    
}
