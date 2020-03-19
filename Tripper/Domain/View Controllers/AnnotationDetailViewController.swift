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
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var arrivalDateLabel: UILabel!
    @IBOutlet weak var departureDateLabel: UILabel!
    
    var isEdit = false
    
    weak var routePoint: RoutePoint!
    weak var delegate: MapRouteDelegate!
    
    private var date: Date = Date()
    
    private let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateStyle = .medium
      formatter.timeStyle = .short
      return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        initGestureRecognizers()
    }
    
    // MARK: - Initializators
    
    private func initUI() {
        configureUI()
    }
    
    private func initGestureRecognizers() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(recognizer:)))
        view.addGestureRecognizer(gesture)
    }

    // MARK: - Actions
    
    @IBAction func editPoint(_ sender: UIButton) {
//        dismiss(animated: true, completion: { [weak self] in
//            guard let self = self else { return }
            self.delegate.mapRoute(performEditFor: self.routePoint)
//        })
    }
    
    @IBAction func deletePoint(_ sender: UIButton) {
        delegate.mapRoute(didDeleted: routePoint)
//        dismiss(animated: true)
    }
    
    // MARK: - Gesture Actions
    
    @objc func onPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: self.view)
            let y = view.frame.minY
            if let superViewHeight = self.view.superview?.frame.height {
                if !(superViewHeight - view.frame.height > y + translation.y) {
                    self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
                }
            }
            recognizer.setTranslation(.zero, in: self.view)
            
        case .cancelled, .ended:
            if view.frame.origin.y > view.frame.height * 2 / 3 {
                toggleView(screenCoverage: 0.75)
            } else if view.frame.origin.y > view.frame.height * 1 / 3 {
                toggleView(screenCoverage: 0.25)
            } else {
                dismiss(animated: true, completion: nil)
            }
            
        default:
            return
        }
    }
    
    func toggleView(screenCoverage percent: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            let height = self.view.frame.height
            let width  = self.view.frame.width
            let yCoordinate = self.view.frame.height * percent
            print(Float(yCoordinate))
            self.view.frame = CGRect(x: 0, y: yCoordinate, width: width, height: height)
        }
    }
    
    // MARK: - Helper Methods
    func configureUI() {
        titleLabel.text = routePoint.title ?? ""
        descriptionTextView.text = routePoint.subtitle ?? ""
        
        if let arrivalDate = routePoint.arrivalDate {
            arrivalDateLabel.text = dateFormatter.string(from: arrivalDate)
        } else {
            arrivalDateLabel.text = "(None)"
        }
        
        if let departureDate = routePoint.departureDate {
            departureDateLabel.text = dateFormatter.string(from: departureDate)
        } else {
            departureDateLabel.text = "(None)"
        }
    }
    
}
