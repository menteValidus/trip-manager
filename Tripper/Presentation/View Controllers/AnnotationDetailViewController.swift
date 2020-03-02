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
    
    struct SeguesIdentifiers {
        static let showDatePicker = "ShowDatePicker"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = routePoint.title ?? "Title"
    }

    // MARK: - Actions
    
    @IBAction func editPoint(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deletePoint(_ sender: UIButton) {
        delegate.mapRoute(didDeleted: routePoint)
        dismiss(animated: true)
    }
    
}
