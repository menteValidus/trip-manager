//
//  AnnotationEditViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 28.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class AnnotationEditViewController: UITableViewController {
    
    private var isDatePickerVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table View's Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return super.numberOfSections(in: tableView)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 3
        default:
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

}
