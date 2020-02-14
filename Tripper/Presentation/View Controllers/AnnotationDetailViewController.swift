//
//  AnnotationDetailViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 06.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

protocol AnnotationDetailDelegate {
    func annotationDetail(didSet time: Date)
}

class AnnotationDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var routePoint: RoutePoint!
    var delegate: MapRouteDelegate!
    
    var isArrivalEditing = true
    private var date: Date = Date()
    
    private let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .short
      return formatter
    }()
    
    struct SeguesIdentifiers {
        static let showDatePicker = "ShowDatePicker"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = routePoint.title ?? "Title"
        titleTextField.text = routePoint.title
        
        descriptionTextView.layer.cornerRadius = 8
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SeguesIdentifiers.showDatePicker {
            let controller = segue.destination as! TimePickerViewController
            let button = sender as! UIButton
            
            switch button.tag {
            case 100:
                isArrivalEditing = true
            case 101:
                isArrivalEditing = false
            default:
                throwAn(errorMessage: "It is impossible to be here!!!")
            }
            
            controller.delegate = self
        }
    }

    // MARK: - Actions
    
    @IBAction func save(_ sender: UIButton) {
        routePoint.title = titleTextField.text
        delegate.mapRoute(didChanged: routePoint)
        dismiss(animated: true)
    }
    
    @IBAction func deletePoint(_ sender: UIButton) {
        delegate.mapRoute(didDeleted: routePoint)
        dismiss(animated: true)
    }
    
    @IBAction func showDatePicker(_ sender: Any) {
        performSegue(withIdentifier: SeguesIdentifiers.showDatePicker, sender: sender)
    }
}

extension AnnotationDetailViewController: AnnotationDetailDelegate {
    func annotationDetail(didSet time: Date) {
        let formattedDate = dateFormatter.string(from: date)
        if isArrivalEditing {
            arrivalDateLabel.text = formattedDate
        } else {
            departureDateLabel.text = formattedDate
        }
    }
    
    
}
