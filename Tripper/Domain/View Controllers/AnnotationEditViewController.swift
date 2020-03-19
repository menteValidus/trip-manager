//
//  AnnotationEditViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 28.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

private enum AnnotationEditState {
    case normal
    case arrivalDateEditing
    case departureDateEditing
}

class AnnotationEditViewController: UITableViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: RoutePointEditDelegate!
    var routePoint: RoutePoint!
    
    private var state: AnnotationEditState = .normal
    private var arrivalDate: Date!
    private var departureDate: Date!

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextView.text = routePoint.subtitle ?? ""
        titleTextField.text = routePoint.title ?? ""
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        
        arrivalDate = routePoint.arrivalDate ?? Date()
        departureDate = routePoint.departureDate ?? arrivalDate
        
        updateDateLabel(in: state)
    }
    
    // MARK: - Actions
    
    @IBAction func save(_ sender: Any) {
        if departureDate < arrivalDate {
            alertWrongDates()
        } else {
            routePoint.title = titleTextField.text!
            routePoint.subtitle = descriptionTextView.text!
            routePoint.arrivalDate = arrivalDate
            routePoint.departureDate = departureDate
            delegate.route(pointEdited: routePoint)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func dataChanged(_ sender: UIDatePicker) {
        switch state {
        case .arrivalDateEditing:
            arrivalDate = sender.date
        case .departureDateEditing:
            departureDate = sender.date
        default:
            return
        }
        
        updateDateLabel(in: state)
    }
    
    // MARK: - Table View's Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell For row at \(indexPath)")
        switch (indexPath.section, indexPath.row) {
        case (2, 1):
            return datePickerCell
            
        case (3, 1):
            return datePickerCell
            
        default:
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of rows in section \(section)")
        switch section {
        case 2:
            if state == .arrivalDateEditing {
                return 2
            } else {
                return super.tableView(tableView, numberOfRowsInSection: section)
            }
            
        case 3:
            if state == .departureDateEditing {
                return 2
            } else {
                return super.tableView(tableView, numberOfRowsInSection: section)
            }
            
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("height for row at \(indexPath)")
        switch (indexPath.section, indexPath.row) {
        case (2, 1):
            return 217
            
        case (3, 1):
            return 217
            
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        print("will select row at \(indexPath)")
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            return indexPath
            
        case (3, 0):
            return indexPath
            
        default:
            return nil
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            switch state {
            case .normal:
                state = .arrivalDateEditing
                showDatePicker(in: state)
                
            case .arrivalDateEditing:
                hideDatePicker(in: state)
                
            case .departureDateEditing:
                hideDatePicker(in: state)
                state = .arrivalDateEditing
                showDatePicker(in: state)
                
            }
            
        case (3, 0):
            switch state {
            case .normal:
                state = .departureDateEditing
                showDatePicker(in: state)
                
            case .arrivalDateEditing:
                hideDatePicker(in: state)
                state = .departureDateEditing
                showDatePicker(in: state)
                
            case .departureDateEditing:
                hideDatePicker(in: state)
                state = .normal
                
            }
            
        default:
            break
                
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        let newIndexPath: IndexPath
        
        switch (indexPath.section, indexPath.row) {
        case (2, 1):
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
            
        case (3, 1):
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
            
        default:
            newIndexPath = indexPath
            
        }
        
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }
    
    // MARK: - Helper Methods
    
    private func showDatePicker(in state: AnnotationEditState) {
        let indexPathDatePicker: IndexPath
        let indexPathDateRow: IndexPath
        let dateToSet: Date
                
        switch state {
        case .normal:
            return
            
        case .arrivalDateEditing:
            indexPathDateRow = IndexPath(row: 0, section: 2)
            indexPathDatePicker = IndexPath(row: 1, section: 2)
            dateToSet = arrivalDate
            
        case .departureDateEditing:
            indexPathDateRow = IndexPath(row: 0, section: 3)
            indexPathDatePicker = IndexPath(row: 1, section: 3)
            dateToSet = departureDate
        }
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.setDate(dateToSet, animated: false)
    }
    
    private func hideDatePicker(in state: AnnotationEditState) {
        let indexPathDatePicker: IndexPath
        let indexPathDateRow: IndexPath
                
        switch state {
        case .normal:
            return
            
        case .arrivalDateEditing:
            indexPathDateRow = IndexPath(row: 0, section: 2)
            indexPathDatePicker = IndexPath(row: 1, section: 2)
            
        case .departureDateEditing:
            indexPathDateRow = IndexPath(row: 0, section: 3)
            indexPathDatePicker = IndexPath(row: 1, section: 3)
        }
        self.state = .normal
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = UIColor.black
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        tableView.endUpdates()
    }
    
    private func updateDateLabel(in state: AnnotationEditState) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        switch state {
        case .arrivalDateEditing:
            arrivalDateLabel.text = formatter.string(from: arrivalDate)
            
        case .departureDateEditing:
            departureDateLabel.text = formatter.string(from: departureDate)
            
        case .normal:
            arrivalDateLabel.text = formatter.string(from: arrivalDate)
            departureDateLabel.text = formatter.string(from: departureDate)
            
        }
    }
    
    private func alertWrongDates() {
        let alert = UIAlertController(title: "Date Mismatch", message: "Date of arrival can't be later than date of departure!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

}

extension AnnotationEditViewController: UITextFieldDelegate {
    // MARK: - Text Field's Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker(in: state)
    }
}

extension AnnotationEditViewController: UITextViewDelegate {
    // MARK: - Text View's Delegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        hideDatePicker(in: state)
    }
}

