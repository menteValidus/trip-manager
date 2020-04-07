//
//  RouteListViewController.swift
//  Tripper
//
//  Created by Denis Cherniy on 03.02.2020.
//  Copyright © 2020 Denis Cherniy. All rights reserved.
//

import UIKit

class RouteListViewController: UITableViewController {
    
    // TODO: INSTEAD OF DI WORKER SHOULD BE USED.
    var subroutes: [Subroute]!
    private var expandedStayingCellRowNumber: Int?
    
    struct TableView {
        struct CellIdentifiers {
            static let roadCell = "RoadCell"
            static let stayingCell = "StayingCell"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        var cellNib = UINib(nibName: TableView.CellIdentifiers.roadCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.roadCell)
        
        cellNib = UINib(nibName: TableView.CellIdentifiers.stayingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.stayingCell)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subroutes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            tableView.beginUpdates()

            let selectedCell = tableView.cellForRow(at: indexPath) as! StayingCell
            if expandedStayingCellRowNumber == indexPath.row {
                expandedStayingCellRowNumber = nil
                selectedCell.isExpanded = false
            } else {
                expandedStayingCellRowNumber = indexPath.row
                selectedCell.isExpanded = true
            }
            
            tableView.endUpdates()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let anotherSubroute = subroutes[indexPath.row]
        
        switch anotherSubroute {
        case is InRoad:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.roadCell, for: indexPath) as! RoadCell
            
            cell.configure(for: anotherSubroute as! InRoad)
            
            return cell
            
        case is Staying:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.stayingCell, for: indexPath) as! StayingCell
            
            cell.configure(for: anotherSubroute as! Staying)
            
//            if expandedStayingCellRowNumber == indexPath.row {
//                cell.isExpanded = true
//            } else if expandedStayingCellRowNumber != indexPath.row && cell.isExpanded {
//                cell.isExpanded = false
//            }
//
            return cell
            
        default:
            display(message: "*** It's impossible to be here!")
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == expandedStayingCellRowNumber {
            return 132.0
        } else if indexPath.row % 2 == 0 {
            if let cell = tableView.cellForRow(at: indexPath) as? StayingCell {
                if cell.isExpanded {
                    cell.isExpanded = false
                }
            }
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}
