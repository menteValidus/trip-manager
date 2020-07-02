//
//  CreateRoutePointViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 07.04.2020.
//  Copyright (c) 2020 Denis Cherniy. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Swinject

protocol CreateRoutePointDisplayLogic: class {
    func displayRoutePointForm(viewModel: CreateRoutePoint.FormRoutePoint.ViewModel)
    func displayFetchDateLimits(viewModel: CreateRoutePoint.FetchDateLimits.ViewModel)
    func displaySaveRoutePoint(viewModel: CreateRoutePoint.SaveRoutePoint.ViewModel)
    func displayCancelCreation(viewModel: CreateRoutePoint.CancelCreation.ViewModel)
    func displaySetDate(viewModel: CreateRoutePoint.SetDate.ViewModel)
    func displayToggleDateEditState(viewModel: CreateRoutePoint.ToggleDateEditState.ViewModel)
    func displayShowDatePicker(viewModel: CreateRoutePoint.ShowDatePicker.ViewModel)
    func displayHideDatePicker(viewModel: CreateRoutePoint.HideDatePicker.ViewModel)
}

class CreateRoutePointViewController: UITableViewController, CreateRoutePointDisplayLogic {
    var interactor: CreateRoutePointBusinessLogic?
    var router: (NSObjectProtocol & CreateRoutePointRoutingLogic & CreateRoutePointDataPassing)?
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CreateRoutePointInteractor()
        let presenter = CreateRoutePointPresenter()
        let router = CreateRoutePointRouter()
        let worker = CreateRoutePointWorker(routePointGateway: Container.shared.resolve(RoutePointGateway.self)!,
                                            orderNumberGenerator: Container.shared.resolve(OrderNumberGenerator.self)!,
                                            dateLimiter: Container.shared.resolve(DateLimiter.self)!)
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formRoutePoint()
        titleTextField.becomeFirstResponder()
        titleTextField.delegate = self
    }
    
    // MARK: - Form Route Point
    
    func formRoutePoint() {
        let request = CreateRoutePoint.FormRoutePoint.Request()
        interactor?.formRoutePoint(request: request)
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    
    func displayRoutePointForm(viewModel: CreateRoutePoint.FormRoutePoint.ViewModel) {
        title = viewModel.navigationTitle
        
        titleTextField.text = viewModel.annotationForm.title
        descriptionTextView.text = viewModel.annotationForm.subtitle
        arrivalDateLabel.text = viewModel.annotationForm.arrivalDate
        departureDateLabel.text = viewModel.annotationForm.departureDate
        
        let requestDateLimits = CreateRoutePoint.FetchDateLimits.Request()
        interactor?.fetchDateLimits(request: requestDateLimits)
    }
    
    // MARK: Fetch Date Limits
    
    func fetchDateLimits() {
        let request = CreateRoutePoint.FetchDateLimits.Request()
        interactor?.fetchDateLimits(request: request)
    }
    
    func displayFetchDateLimits(viewModel: CreateRoutePoint.FetchDateLimits.ViewModel) {
        
    }
    
    // MARK: Save Route Point
    
    @IBAction func save(_ sender: Any) {
        let title = titleTextField.text!
        let description = descriptionTextView.text!
        
        let request = CreateRoutePoint.SaveRoutePoint.Request(title: title, description: description)
        interactor?.saveRoutePoint(request: request)
    }
    
    func displaySaveRoutePoint(viewModel: CreateRoutePoint.SaveRoutePoint.ViewModel) {
        if let errorMessage = viewModel.errorMessage {
            showCreationFailure(title: "Date Error!", message: errorMessage)
            return
        }
        router?.routeToManageRouteMap(segue: nil)
    }
    
    // MARK: Error Handling
    
    func showCreationFailure(title: String = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        showDetailViewController(alertController, sender: nil)
    }
    
    // MARK: Cancel Creation
    
    @IBAction func cancel(_ sender: Any) {
        let request = CreateRoutePoint.CancelCreation.Request()
        interactor?.cancelCreation(request: request)
    }
    
    func displayCancelCreation(viewModel: CreateRoutePoint.CancelCreation.ViewModel) {
        router?.routeToManageRouteMapWithCancel(segue: nil)
    }
    
    // MARK: Set Date
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let newDate = sender.date
        
        let request = CreateRoutePoint.SetDate.Request(newDate: newDate)
        interactor?.setDate(request: request)
    }
    
    func displaySetDate(viewModel: CreateRoutePoint.SetDate.ViewModel) {
        switch viewModel.state {
        case .arrivalDateEditing:
            arrivalDateLabel.text = viewModel.dateString
        case .departureDateEditing:
            departureDateLabel.text = viewModel.dateString
        default:
            fatalError("*** If Set Date use case is called it means that some of the dates must be editing.")
        }
    }
    
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Table View's Delegate
    
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
            return numberOfRowsInArrivalSection
            
        case 3:
            return numberOfRowsInDepartureSection
            
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            return indexPath
            
        case (3, 0):
            return indexPath
            
        default:
            return nil
            
        }
    }
    
    // MARK: Toggle Date Edit State
    
    private var numberOfRowsInArrivalSection = 1
    private var numberOfRowsInDepartureSection = 1
    
    func displayToggleDateEditState(viewModel: CreateRoutePoint.ToggleDateEditState.ViewModel) {
        
        if viewModel.oldState != .normal && viewModel.newState == .normal {
            let requestToHide = CreateRoutePoint.HideDatePicker.Request(state: viewModel.oldState)
            interactor?.hideDatePicker(request: requestToHide)
            return
        }
        
        if viewModel.oldState != viewModel.newState && viewModel.oldState != .normal && viewModel.newState != .normal {
            let requestToHide = CreateRoutePoint.HideDatePicker.Request(state: viewModel.oldState)
            interactor?.hideDatePicker(request: requestToHide)
            let requestToShow = CreateRoutePoint.ShowDatePicker.Request(state: viewModel.newState)
            interactor?.showDatePicker(request: requestToShow)
            
            return
        }
        
        if viewModel.oldState == .normal && viewModel.newState != .normal {
            let requestToShow = CreateRoutePoint.ShowDatePicker.Request(state: viewModel.newState)
            interactor?.showDatePicker(request: requestToShow)
            
            return
        }
        
        if viewModel.oldState != .normal && viewModel.newState == .normal {
            let requestToShow = CreateRoutePoint.ShowDatePicker.Request(state: viewModel.newState)
            interactor?.showDatePicker(request: requestToShow)
            
            return
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        titleTextField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
        
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            titleTextField.becomeFirstResponder()
            
        case (1, 0):
            descriptionTextView.becomeFirstResponder()
            
        case (2, 0):
            let request = CreateRoutePoint.ToggleDateEditState.Request(section: 2, row: 0)
            interactor?.toggleDateEditState(request: request)
            
        case (3, 0):
            let request = CreateRoutePoint.ToggleDateEditState.Request(section: 3, row: 0)
            interactor?.toggleDateEditState(request: request)
            
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
    
    // MARK: Show Date Picker
    
    func displayShowDatePicker(viewModel: CreateRoutePoint.ShowDatePicker.ViewModel) {
        let indexPathDatePicker: IndexPath
        let indexPathDateRow: IndexPath
        
        switch viewModel.state {
        case .normal:
            return
            
        case .arrivalDateEditing:
            numberOfRowsInArrivalSection = 2
            indexPathDateRow = IndexPath(row: 0, section: 2)
            indexPathDatePicker = IndexPath(row: 1, section: 2)
            
        case .departureDateEditing:
            numberOfRowsInDepartureSection = 2
            indexPathDateRow = IndexPath(row: 0, section: 3)
            indexPathDatePicker = IndexPath(row: 1, section: 3)
        }
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.endUpdates()
        
        datePicker.date = viewModel.date
    }
    
    // MARK: Hide Date Picker
    
    func displayHideDatePicker(viewModel: CreateRoutePoint.HideDatePicker.ViewModel) {
        let indexPathDatePicker: IndexPath
        let indexPathDateRow: IndexPath
        
        switch viewModel.state {
        case .normal:
            return
            
        case .arrivalDateEditing:
            numberOfRowsInArrivalSection = 1
            indexPathDateRow = IndexPath(row: 0, section: 2)
            indexPathDatePicker = IndexPath(row: 1, section: 2)
            
        case .departureDateEditing:
            numberOfRowsInDepartureSection = 1
            indexPathDateRow = IndexPath(row: 0, section: 3)
            indexPathDatePicker = IndexPath(row: 1, section: 3)
        }
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow) {
            dateCell.detailTextLabel!.textColor = UIColor.black
        }
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPathDateRow], with: .none)
        tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
        tableView.endUpdates()
    }
}

extension CreateRoutePointViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionTextView.becomeFirstResponder()
    }
}
