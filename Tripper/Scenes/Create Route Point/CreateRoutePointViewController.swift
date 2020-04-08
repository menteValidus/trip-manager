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

protocol CreateRoutePointDisplayLogic: class {
    func displayRoutePointForm(viewModel: CreateRoutePoint.FormRoutePoint.ViewModel)
    func displaySaveRoutePoint(viewModel: CreateRoutePoint.SaveRoutePoint.ViewModel)
    func displayCancelCreation(viewModel: CreateRoutePoint.CancelCreation.ViewModel)
}

class CreateRoutePointViewController: UITableViewController, CreateRoutePointDisplayLogic {
    var interactor: CreateRoutePointBusinessLogic?
    var router: (NSObjectProtocol & CreateRoutePointRoutingLogic & CreateRoutePointDataPassing)?
    
    // MARK: Object lifecycle
    
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
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formRoutePoint()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    
    func formRoutePoint() {
        let request = CreateRoutePoint.FormRoutePoint.Request()
        interactor?.formRoutePoint(request: request)
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    
    func displayRoutePointForm(viewModel: CreateRoutePoint.FormRoutePoint.ViewModel) {
        titleTextField.text = viewModel.annotationForm.title
        descriptionTextView.text = viewModel.annotationForm.subtitle
        arrivalDateLabel.text = viewModel.annotationForm.arrivalDate
        departureDateLabel.text = viewModel.annotationForm.departureDate
    }
    
    // MARK: Cancel Creation
    
    @IBAction func cancel(_ sender: Any) {
    }
    
    func displayCancelCreation(viewModel: CreateRoutePoint.CancelCreation.ViewModel) {
        
    }
    
    // MARK: Save Route Point
    
    @IBAction func save(_ sender: Any) {
        let title = titleTextField.text!
        let description = descriptionTextView.text!
        let arrivalDate = Date()
        let departureDate = Date()
        
        let request = CreateRoutePoint.SaveRoutePoint.Request(
            title: title, description: description, arrivalDate: arrivalDate, departureDate: departureDate)
        interactor?.saveRoutePoint(request: request)
    }
    
    func displaySaveRoutePoint(viewModel: CreateRoutePoint.SaveRoutePoint.ViewModel) {
        router?.routeToManageRouteMap(segue: nil)
    }
    
}
